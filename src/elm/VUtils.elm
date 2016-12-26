module VUtils exposing (..)

import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE

-- LOCAL IMPORTS

import Msg exposing (..)


(=>) : a -> a -> ( a, a )
(=>) a b = ( a, b )

checkBox : Msg -> Bool -> Bool -> String -> String -> Html Msg
checkBox msg val disabled lbl id =
    Html.div
        [ HA.class "pure-controls"
        , HA.class "kbsymanz-checkbox-wrapper"
        ]
        [ Html.label
            [ HA.for id
            , HA.class "pure-checkbox"
            ]
            [ Html.input
                [ HA.type_ "checkbox"
                , HE.onClick msg
                , HA.checked val
                , HA.disabled disabled
                , HA.id id
                ]
                []
            , Html.text lbl
            ]
        ]


textfieldString : (String -> Msg) -> String -> Bool -> String -> String -> String -> Html Msg
textfieldString msg val disabled lbl id inputClass =
    Html.div
        [ HA.class "kbsymanz-textfieldString" ]
        [ Html.label
            [ HA.for id ]
            [ Html.text lbl ]
        , Html.input
            [ HA.id id
            , HE.onInput msg
            , HA.value val
            , HA.disabled disabled
            , HA.type_ "text"
            , HA.class inputClass
            ]
            []
        ]

textfieldStringML : (String -> Msg) -> String -> Bool -> String -> String -> String -> Int -> Html Msg
textfieldStringML msg val disabled lbl id inputClass rows =
    Html.div
        [ HA.class "kbsymanz-textfieldString" ]
        [ Html.label
            [ HA.for id ]
            [ Html.text lbl ]
        , Html.textarea
            [ HA.id id
            , HE.onInput msg
            , HA.value val
            , HA.disabled disabled
            , HA.class inputClass
            , HA.rows rows
            ]
            []
        ]


button : Msg -> String -> Html Msg
button msg lbl =
    Html.button
        [ HA.class "pure-button"
        , HA.class "kbsymanz-button"
        , HE.onClick msg
        ]
        [ Html.text lbl ]
