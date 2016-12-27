module Views.Posts exposing (view, viewPostsList)

import Date
import Dict exposing (Dict)
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U
import VUtils as VU exposing ((=>))


view : Model -> Html Msg
view model =
    let
        cPost =
            Dict.get model.currentPost model.posts

        content =
            case cPost of
                Just p ->
                    Html.div [ HA.class "pure-g" ]
                        [ Html.div [ HA.class "pure-u-1" ]
                            [ Html.p [ HA.class "kbsymanz-headingStyle" ]
                                [ Html.text p.title ]
                            , VU.button SavePost "Save"
                            , VU.button (DelPost model.currentPost) "Delete"
                            , postForm p model
                            ]
                        ]

                Nothing ->
                    Html.div [ HA.class "pure-g" ]
                        [ Html.div [ HA.class "pure-u-1" ]
                            [ Html.text "" ]
                        ]
    in
        content


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
        Html.form [ HA.class "pure-form pure-form-stacked kbsymanz-form" ]
            [ Html.div [ HA.class "kbsymanz-form-field" ]
                [ Html.text <| "Id: " ++ (toString post.id) ]
            , Html.div [ HA.class "kbsymanz-form-field" ]
                [ Html.text <| "Author: " ++ authorName ++ " (set a different default author and save to change)" ]
            , VU.textfieldString PostTitle
                post.title
                False
                "Title"
                "postTitleId"
                "pure-input-1-2"
            , VU.textfieldString PostTags
                post.tags
                False
                "Tags (separate with spaces)"
                "postTagsId"
                "pure-input-1-2"
            , VU.textfieldStringML PostBody
                post.body
                False
                "Body"
                "postBodyId"
                "pure-input-1"
                15
            ]


viewPostsList : Model -> Html Msg
viewPostsList model =
    let
        posts =
            Dict.values model.posts
                |> List.sortBy (\p -> Date.toTime p.mDate)
                |> List.reverse

        buildRow post =
            let
                mDate =
                    (U.monthToString <| Date.month post.mDate)
                        ++ " "
                        ++ (String.padLeft 2 '0' <| toString <| Date.day post.mDate)
                        ++ ", "
                        ++ (toString <| Date.year post.mDate)
            in
                Html.div
                    [ HA.class "pure-u-1"
                    , HA.style
                        [ "border-bottom" => "1px dotted #888888"
                        ]
                    , HE.onClick <| SelectPost post.id
                    ]
                    [ Html.h4 []
                        [ Html.text <| post.title ]
                    , Html.div []
                        [ Html.text mDate ]
                    ]
    in
        Html.div [ HA.class "pure-g" ]
            <| [ Html.div [ HA.class "pure-u-1" ]
                    [ Html.span [ HA.class "kbsymanz-headingStyle2" ]
                        [ Html.text <| "Posts" ++ " " ]
                    , VU.button NewPost "New"
                    ]
               ]
            ++ (List.map buildRow posts)
