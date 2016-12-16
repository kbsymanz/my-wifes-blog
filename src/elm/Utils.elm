module Utils exposing (..)

import Date
import Dict exposing (Dict)
import Html exposing (Html)
import Material
import Material.Options as Options
import Material.Textfield as Textfield


-- LOCAL IMPORTS

import Model exposing (Mdl, Id, Author)
import Msg exposing (..)


monthToString : Date.Month -> String
monthToString month =
    case month of
        Date.Jan ->
            "January"

        Date.Feb ->
            "February"

        Date.Mar ->
            "March"

        Date.Apr ->
            "April"

        Date.May ->
            "May"

        Date.Jun ->
            "June"

        Date.Jul ->
            "July"

        Date.Aug ->
            "August"

        Date.Sep ->
            "September"

        Date.Oct ->
            "October"

        Date.Nov ->
            "November"

        Date.Dec ->
            "December"


dayToString : Date.Day -> String
dayToString day =
    case day of
        Date.Mon ->
            "Monday"

        Date.Tue ->
            "Tuesday"

        Date.Wed ->
            "Wednesday"

        Date.Thu ->
            "Thursday"

        Date.Fri ->
            "Friday"

        Date.Sat ->
            "Saturday"

        Date.Sun ->
            "Sunday"


textfieldStringML : Material.Model -> List Int -> String -> String -> (String -> Msg) -> Int -> Html Msg
textfieldStringML mdl context lbl strVal msg rows =
    Textfield.render Mdl
        context
        mdl
        [ Textfield.label lbl
        , Textfield.floatingLabel
        , Textfield.textarea
        , Textfield.rows rows
        , Textfield.value strVal
        , Textfield.onInput <| msg
        ]


textfieldString : Material.Model -> List Int -> String -> String -> (String -> Msg) -> Html Msg
textfieldString mdl context lbl strVal msg =
    Textfield.render Mdl
        context
        mdl
        [ Textfield.label lbl
        , Textfield.floatingLabel
        , Textfield.value strVal
        , Textfield.onInput <| msg
        , Options.inner
            [ Options.css "width" "100%"
            ]
        ]


authorsFromList : List Author -> Dict Id Author
authorsFromList authors =
    Dict.fromList <| List.map (\a -> ( a.id, a )) authors
