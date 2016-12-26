module View exposing (view)

import Color
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import List.Extra as LE
import Material.Icons.Action exposing (settings)


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U
import Views.Authors as VAuthors
import Views.Posts as VPosts
import Views.Settings as VSettings
import VUtils as VU exposing ((=>))



view : Model -> Html Msg
view model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-1" ]
            [ headerSmall "Blog Manager" model ]
        , Html.div [ HA.class "pure-u-1" ]
            [ viewMain model ]
        ]


headerSmall : String -> Model -> Html Msg
headerSmall title model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-xl-23-24 pure-u-lg-11-12 pure-u-md-5-6 pure-u-sm-3-4" ]
            [ Html.div
                [ HA.class "kbsymanz-appHeaderStyle" ]
                [ Html.text title ]
            ]
        , Html.div
            [ HA.class "pure-u-xl-1-24 pure-u-lg-1-12 pure-u-md-1-6 pure-u-sm-1-4"
            , HE.onClick SelectSettings
            ]
            [ Html.div
                [ HA.class "kbsymanz-appHeaderStyle" ]
                [ settings Color.grey 40 ]
            ]
        ]


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
            VPosts.view model

        ViewAuthor ->
            VAuthors.view model

        ViewSettings ->
            VSettings.view model


viewMain : Model -> Html Msg
viewMain model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-1-3" ]
            [ postsAuthorsList model ]
        , Html.div [ HA.class "pure-u-2-3" ]
            [ viewContent model ]
        ]
