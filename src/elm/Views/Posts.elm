module Views.Posts exposing (view, viewPostsList)

import Date
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Grid as Grid
import Material.Layout as Layout
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Typography as Typo


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U


postsContext : Int
postsContext =
    3000


view : Model -> Html Msg
view model =
    let
        cPost =
            Dict.get model.currentPost model.posts

        title =
            case cPost of
                Just t ->
                    t.title

                Nothing ->
                    ""
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
                        [ Html.text <| title
                        , saveBtn model
                        , deleteBtn model
                        ]
                    ]
                , case cPost of
                    Just p ->
                        postForm p model
                    Nothing ->
                        Html.text ""
                ]
            ]


postForm : Post -> Model -> Html Msg
postForm post model =
    let
        ( authorName, authorId ) =
            case Dict.get post.authorId model.authors of
                Just a ->
                    ( a.firstname ++ " " ++ a.lastname, Just post.authorId )

                Nothing ->
                    ( "Not Found", Nothing )
    in
        Html.div []
            [ Html.text <| "Id: " ++ (toString post.id)
            , Html.br [] []
            , Html.text <| "Author: " ++ authorName ++ " (set a different default author and save to change)"
            , Html.br [] []
            , U.textfieldString model.mdl
                [ postsContext, 0 ]
                "Title"
                post.title
                (\t -> PostTitle t)
            , Html.br [] []
            , U.textfieldString model.mdl
                [ postsContext, 1 ]
                "Tags (separate with spaces)"
                post.tags
                (\t -> PostTags t)
            , Html.br [] []
            , U.textfieldStringML model.mdl
                [ postsContext, 2 ]
                "Body"
                post.body
                (\b -> PostBody b)
                20
            ]


saveBtn : Model -> Html Msg
saveBtn model =
    Button.render Mdl
        [ postsContext, 100 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick SavePost
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Save" ]


deleteBtn : Model -> Html Msg
deleteBtn model =
    Button.render Mdl
        [ postsContext, 102 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick (DelPost model.currentPost)
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Delete" ]


newBtn : Model -> Html Msg
newBtn model =
    Button.render Mdl
        [ postsContext, 103 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick NewPost
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "New" ]


viewPostsList : Model -> Html Msg
viewPostsList model =
    let
        posts =
            Dict.values model.posts

        buildRow post =
            let
                mDate =
                    (U.monthToString <| Date.month post.mDate)
                        ++ " "
                        ++ (String.padLeft 2 '0' <| toString <| Date.day post.mDate)
                        ++ ", "
                        ++ (toString <| Date.year post.mDate)
            in
                Layout.row []
                    [ Layout.title []
                        [ Card.view
                            [ Options.attribute <| HE.onClick <| SelectPost post.id
                            ]
                            [ Card.title []
                                [ Card.head []
                                    [ Html.text post.title
                                    ]
                                , Card.subhead []
                                    [ Html.text mDate
                                    ]
                                ]
                            ]
                        ]
                    ]
    in
        Html.div
            [ HA.style
                [ ( "height", "75%" )
                , ( "min-height", "75%" )
                , ( "scroll-y", "auto" )
                ]
            ]
            <| [ Layout.row []
                    [ Layout.title []
                        [ Options.styled Html.p
                            [ Typo.display2 ]
                            [ Html.text "Posts"
                            , newBtn model
                            ]
                        ]
                    ]
               ]
            ++ List.map buildRow posts
