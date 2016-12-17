module View exposing (view)

import Color
import Html exposing (Html)
import Html.Events as HE
import List.Extra as LE
import Material
import Material.Card as Card
import Material.Grid as Grid
import Material.Icons.Action exposing (settings, settings_application)
import Material.Layout as Layout
import Material.Options as Options
import Material.Snackbar as Snackbar
import Material.Typography as Typo


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
