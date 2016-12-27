module Views.Authors exposing (view, viewAuthorsList)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import List.Extra as LE


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U
import VUtils as VU exposing ((=>))


view : Model -> Html Msg
view model =
    let
        author =
            Dict.get model.currentAuthor model.authors

        content =
            case author of
                Just a ->
                    Html.div
                        [ HA.class "pure-g" ]
                        [ Html.div [ HA.class "pure-u-1" ]
                            [ Html.p [ HA.class "kbsymanz-headingStyle" ]
                                [ Html.text <| a.firstname ++ " " ++ a.lastname ]
                            , VU.button SaveAuthors "Save"
                            , VU.button (DelAuthor model.currentAuthor) "Delete"
                            , authorForm author model
                            ]
                        ]
                Nothing ->
                    Html.div
                        [ HA.class "pure-g" ]
                        [ Html.div [ HA.class "pure-u-1" ]
                            [ Html.text "" ]
                        ]
    in
        content


authorForm : Maybe Author -> Model -> Html Msg
authorForm author model =
    let
        ( id, firstname, lastname, email ) =
            case author of
                Just a ->
                    ( a.id, a.firstname, a.lastname, a.email )

                Nothing ->
                    ( -100, "", "", "" )

        defaultAuthorMsg =
            if model.defaultAuthor == Nothing then
                SetDefaultAuthor (Just id)
            else if model.defaultAuthor == Just id then
                SetDefaultAuthor Nothing
            else
                SetDefaultAuthor (Just id)
    in
        Html.div
            [ HA.class "kbsymanz-form" ]
            [ Html.text
                <| "Id: "
                ++ if author == Nothing then
                    "100"
                   else
                    (toString id)
            , Html.br [] []
            , Html.form [ HA.class "pure-form pure-form-stacked" ]
                [ Html.fieldset []
                    [ VU.checkBox defaultAuthorMsg
                        (model.defaultAuthor == Just id)
                        (if author == Nothing then
                            True
                         else
                            False
                        )
                        "Make the default author"
                        "defaultAuthorId"
                    , VU.textfieldString AuthorFirstname
                        firstname
                        (if author == Nothing then
                            True
                         else
                            False
                        )
                        "First name"
                        "firstnameId"
                        ""
                    , VU.textfieldString AuthorLastname
                        lastname
                        (if author == Nothing then
                            True
                         else
                            False
                        )
                        "Last name"
                        "lastnameId"
                        ""
                    , VU.textfieldString AuthorEmail
                        email
                        (if author == Nothing then
                            True
                         else
                            False
                        )
                        "Email"
                        "emailId"
                        ""
                    ]
                ]
            ]


viewAuthorsList : Model -> Html Msg
viewAuthorsList model =
    let
        buildRow author =
            Html.h4
                [ HA.class "pure-u-1"
                , HE.onClick <| SelectAuthor author.id
                ]
                [ Html.text <| author.firstname ++ " " ++ author.lastname ]
    in
        Html.div
            [ HA.class "pure-g" ]
            <| [ Html.div [ HA.class "pure-u-1" ]
                    [ Html.span [ HA.class "kbsymanz-headingStyle2" ]
                        [ Html.text <| "Authors" ++ " " ]
                    , VU.button NewAuthor "New"
                    ]
               ]
            ++ (List.map buildRow <| Dict.values model.authors)
