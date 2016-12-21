module View2 exposing (view)

import Color
import Html exposing (Html, node)
import Html.Attributes as HA
import Html.Events as HE
import List.Extra as LE
import Polymer.App as App
import Polymer.Paper as Paper


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U
import Views.Authors as VAuthors
import Views.Posts as VPosts
import Views.Settings as VSettings


-- TODO: do I want a layout? Is that what is forcing wasted space on the left?


view : Model -> Html Msg
view model =
    App.headerLayout
        []
        [ App.header
            [ HA.attribute "fixed" "true"
            , HA.attribute "background-color" "#696969"
            , HA.attribute "height" "300px"
            ]
            [ App.toolbar
                []
                [ Html.h1
                    []
                    [ Html.text "Markdown Manager" ]
                ]
            ]
        , Html.div
            []
            [ App.drawerLayout
                []
                [ drawer model
                , contents model
                ]
            ]
        ]


drawer : Model -> Html Msg
drawer model =
    App.drawer
        [ HA.class "drawer-contents"
        , HA.attribute "opened" "true"
        , HA.attribute "align" "left"
        , HA.attribute "app-drawer-width" "200px"
        ]
        [ Html.div
            [ HA.attribute "height" "100%"
            , HA.attribute "overflow" "auto"
            ]
            [ Html.text "This is text that I suppose should wrap within the drawer on the left. If it does not wrap, well, I'm not sure about that."
            ]
        ]

contents : Model -> Html Msg
contents model =
    Html.div
        [
        ]
        [ Html.text "contents"
        ]

    {-:
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader
        , Layout.fixedDrawer
        ]
        { header = headerSmall "Blog Manager" model
        , drawer = []
        , tabs = ( [], [] )
        , main = [ viewMain model ]
        }


headerSmall : String -> Model -> List (Html Msg)
headerSmall title model =
    let
        contents =
            [ Layout.row []
                [ Layout.title []
                    [ Options.styled Html.p [ Typo.headline ] [ Html.text title ] ]
                , Layout.spacer
                , Html.div [ HE.onClick <| SelectSettings ]
                    [ settings Color.white 40 ]
                ]
            ]
    in
        contents


postsAuthorsList : Model -> Html Msg
postsAuthorsList model =
    let
        contents =
            Html.div []
                [ VPosts.viewPostsList model
                , VAuthors.viewAuthorsList model
                ]
    in
        contents


viewContent : Model -> Html Msg
viewContent model =
    case model.viewContent of
        ViewPost ->
            --viewContentPost model
            VPosts.view model

        ViewAuthor ->
            VAuthors.view model

        ViewSettings ->
            VSettings.view model


viewMain : Model -> Html Msg
viewMain model =
    Html.div []
        [ Grid.grid []
            [ Grid.cell
                [ Grid.size Grid.Desktop 4
                , Grid.size Grid.Tablet 3
                , Grid.size Grid.Phone 4
                ]
                [ postsAuthorsList model ]
            , Grid.cell
                [ Grid.size Grid.Desktop 8
                , Grid.size Grid.Tablet 5
                , Grid.size Grid.Phone 4
                ]
                [ viewContent model
                , Html.map (\m -> Toast m) <| Snackbar.view model.toast
                ]
            ]
        ]

-}
