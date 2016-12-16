module Views.Authors exposing (view, viewAuthorsList)

import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import List.Extra as LE
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Grid as Grid
import Material.Layout as Layout
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Toggles as Toggles
import Material.Typography as Typo


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U


authorsContext : Int
authorsContext =
    2000


view : Model -> Html Msg
view model =
    let
        author =
            --LE.find (\a -> a.id == model.currentAuthor) model.authors
            Dict.get model.currentAuthor model.authors

        ( fname, lname ) =
            case author of
                Just a ->
                    ( a.firstname, a.lastname )

                Nothing ->
                    ( "Not", "Found" )
    in
        Grid.grid []
            [ Grid.cell
                [ Grid.size Grid.Desktop 12
                , Grid.size Grid.Tablet 8
                , Grid.size Grid.Phone 4
                ]
                [ Options.styled Html.p
                    [ Typo.display2 ]
                    [ Html.span []
                        [ Html.text <| fname ++ " " ++ lname
                        , saveBtn model
                        , deleteBtn model
                        ]
                    ]
                , authorForm author model
                  --, Html.p []
                  --[ Html.text <| toString model ]
                ]
            ]


saveBtn : Model -> Html Msg
saveBtn model =
    Button.render Mdl
        [ authorsContext, 100 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick SaveAuthors
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Save" ]


deleteBtn : Model -> Html Msg
deleteBtn model =
    Button.render Mdl
        [ authorsContext, 102 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick (DelAuthor model.currentAuthor)
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Delete" ]


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
        Html.div []
            [ Html.text
                <| "Id: "
                ++ if author == Nothing then
                    ""
                   else
                    (toString id)
            , Toggles.checkbox Mdl
                [ authorsContext, 10 ]
                model.mdl
                [ Toggles.onClick defaultAuthorMsg
                , Toggles.ripple
                , Toggles.value (model.defaultAuthor == Just id)
                , if author == Nothing then
                    Options.disabled True
                  else
                    Options.disabled False
                ]
                [ Html.text "Make the default author" ]
            , Html.br [] []
            , U.textfieldString model.mdl
                [ authorsContext, 0 ]
                "First name"
                firstname
                (\f -> AuthorFirstname f)
            , Html.br [] []
            , U.textfieldString model.mdl
                [ authorsContext, 1 ]
                "Last name"
                lastname
                (\l -> AuthorLastname l)
            , Html.br [] []
            , U.textfieldString model.mdl
                [ authorsContext, 2 ]
                "Email"
                email
                (\e -> AuthorEmail e)
            ]


viewAuthorsList : Model -> Html Msg
viewAuthorsList model =
    let
        buildRow author =
            Layout.row []
                [ Layout.title []
                    [ Card.view
                        [ Options.attribute <| HE.onClick <| SelectAuthor author.id
                        ]
                        [ Card.title []
                            [ Card.head []
                                [ Html.text <| author.firstname ++ " " ++ author.lastname
                                ]
                            ]
                        ]
                    ]
                ]
    in
        Html.div
            [ HA.style
                [ ( "height", "25%" )
                , ( "min-height", "25%" )
                , ( "scroll-y", "auto" )
                ]
            ]
            <| [ Layout.row []
                    [ Layout.title []
                        [ Options.styled Html.p
                            [ Typo.display2 ]
                            [ Html.text "Authors"
                            , newBtn model
                            ]
                        ]
                    ]
               ]
            ++ (List.map buildRow <| Dict.values model.authors)


newBtn : Model -> Html Msg
newBtn model =
    Button.render Mdl
        [ authorsContext, 101 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick NewAuthor
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "New" ]
