module Views.Posts exposing (view)

import Dict exposing (Dict)
import Html exposing (Html)
import List.Zipper as Zipper
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Grid as Grid
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
            Zipper.current model.posts

        title =
            cPost.title
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
                , postForm cPost model
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
          --, Button.onClick (DelAuthor model.currentAuthor)
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Delete" ]
