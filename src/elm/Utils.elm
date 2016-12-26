module Utils exposing (..)

import Date
import Dict exposing (Dict)
import Html exposing (Html)
import Material
import Material.Options as Options
import Material.Textfield as Textfield


-- LOCAL IMPORTS

import Model exposing (Mdl, Id, Author, PostStatus(..))
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


authorsFromList : List Author -> Dict Id Author
authorsFromList authors =
    Dict.fromList <| List.map (\a -> ( a.id, a )) authors


postStatusToString : PostStatus -> String
postStatusToString status =
    case status of
        NotPublished ->
            "NotPublished"

        Published ->
            "Published"

        PublishedButChanged ->
            "PublishedButChanged"


stringToPostStatus : String -> PostStatus
stringToPostStatus str =
    case str of
        "NotPublished" ->
            NotPublished
        "Published" ->
            Published
        "PublishedButChanged" ->
            PublishedButChanged
        _ ->
            let
                _ =
                    Debug.log "stringToPostStatus" <| "Error: unknown value passed: " ++ str
            in
                Published


