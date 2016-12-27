module Views.Settings exposing (view)

import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U
import VUtils as VU


settingsForm : Model -> Html Msg
settingsForm model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-1" ]
            [ Html.form [ HA.class "pure-form pure-form-stacked" ]
                [ VU.textfieldString ServerImagesPushCmd
                    model.config.serverImagesPushCmd
                    False
                    "Command to push images to the server"
                    "serverImagesPushCmdId"
                    "pure-input-1"
                , VU.textfieldString ServerPostsPushCmd
                    model.config.serverPostsPushCmd
                    False
                    "Command to push posts to the server"
                    "serverPostsPushCmdId"
                    "pure-input-1"
                , VU.textfieldString ServerTriggerCmd
                    model.config.serverTriggerCmd
                    False
                    "Server trigger command"
                    "serverTriggerCmdId"
                    "pure-input-1"
                , VU.textfieldString PostsDirectory
                    model.config.postsDirectory
                    False
                    "Local posts directory"
                    "postsDirectoryId"
                    "pure-input-1"
                , VU.textfieldString ImagesDirectory
                    model.config.imagesDirectory
                    False
                    "Local images directory"
                    "imagesDirectoryId"
                    "pure-input-1"
                , VU.textfieldString PostCss
                    model.config.postCss
                    False
                    "CSS for each post"
                    "postCssId"
                    "pure-input-1"
                , VU.textfieldString PostTemplate
                    model.config.postTemplate
                    False
                    "Fill template for each post"
                    "postTemplateId"
                    "pure-input-1"
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    Html.div [ HA.class "pure-g" ]
        [ Html.div [ HA.class "pure-u-1" ]
            [ Html.p [ HA.class "kbsymanz-headingStyle" ] [ Html.text "Settings" ]
            , VU.button SaveSettings "Save"
            , settingsForm model
            ]
        ]
