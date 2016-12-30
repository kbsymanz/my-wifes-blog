module View exposing (view)

import Color
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import List.Extra as LE
import Material.Icons.Action exposing (settings)
import Material.Icons.Image exposing (remove_red_eye)


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
        , Html.div [ HA.class "pure-u-1 one-box" ]
            [ viewMain model ]
        ]


headerSmall : String -> Model -> Html Msg
headerSmall title model =
    let
        uMsg =
            case model.userMessage of
                Just str ->
                    str

                Nothing ->
                    ""
        ( previewColor, previewMsg ) =
            case model.viewContent of
                ViewPost ->
                    ( Color.white, EditPosts )

                EditPost ->
                    ( Color.grey, ViewPosts )

                _ ->
                    ( Color.grey, ViewPosts )
    in
        Html.div [ HA.class "pure-g" ]
            [ Html.div [ HA.class "pure-u-xl-22-24 pure-u-lg-10-12 pure-u-md-4-6 pure-u-sm-2-4" ]
                [ Html.div [ HA.class "kbsymanz-appHeaderStyle kbsymanz-appHeaderStyle-left" ]
                    [ Html.text title ]
                ]
            , Html.div
                [ HA.class "pure-u-xl-1-24 pure-u-lg-1-12 pure-u-md-1-6 pure-u-sm-1-4"
                , HE.onClick ViewPosts
                ]
                [ Html.div [ HA.class "kbsymanz-appHeaderStyle kbsymanz-appHeaderStyle-right" ]
                    [ remove_red_eye previewColor 40 ]
                ]
            , Html.div
                [ HA.class "pure-u-xl-1-24 pure-u-lg-1-12 pure-u-md-1-6 pure-u-sm-1-4"
                , HE.onClick SelectSettings
                ]
                [ Html.div [ HA.class "kbsymanz-appHeaderStyle kbsymanz-appHeaderStyle-right" ]
                    [ settings Color.grey 40 ]
                ]
            , Html.div [ HA.class "pure-u-1 one-box kbsymanz-appHeaderUserMessage" ]
                [ Html.text uMsg ]
            ]


postsAuthorsList : Model -> Html Msg
postsAuthorsList model =
    let
        contentFunction =
            case model.viewContent of
                EditPost ->
                    VPosts.viewPostsList

                EditAuthor ->
                    VAuthors.viewAuthorsList

                _ ->
                    VPosts.viewPostsList

        contents =
            Html.div [ HA.class "pure-menu pure-menu-horizontal" ]
                [ Html.ul [ HA.class "pure-menu-list" ]
                    [ Html.li
                        [ HA.class "pure-menu-item"
                        , if model.viewContent == ViewPost || model.viewContent == ViewNothing then
                            HA.class "pure-menu-selected"
                          else
                            HA.class ""
                        ]
                        [ Html.a
                            [ HA.attribute "href" "#"
                            , HA.class "pure-menu-link"
                            , HE.onClick EditPosts
                            ]
                            [ Html.text "Posts" ]
                        ]
                    , Html.li
                        [ HA.class "pure-menu-item"
                        , if model.viewContent == EditAuthor then
                            HA.class "pure-menu-selected"
                          else
                            HA.class ""
                        ]
                        [ Html.a
                            [ HA.attribute "href" "#"
                            , HA.class "pure-menu-link"
                            , HE.onClick EditAuthors
                            ]
                            [ Html.text "Authors" ]
                        ]
                    ]
                , contentFunction model
                ]
    in
        contents


viewContent : Model -> Html Msg
viewContent model =
    case model.viewContent of
        ViewPost ->
            VPosts.preview model

        EditPost ->
            VPosts.view model

        EditAuthor ->
            VAuthors.view model

        EditSettings ->
            VSettings.view model

        ViewNothing ->
            Html.div []
                [ Html.text "" ]


viewMain : Model -> Html Msg
viewMain model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-1-4 one-box" ]
            [ postsAuthorsList model ]
        , Html.div [ HA.class "pure-u-3-4 one-box" ]
            [ viewContent model ]
        ]
