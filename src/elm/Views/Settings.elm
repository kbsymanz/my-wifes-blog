module Views.Settings exposing (view)

import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Result
import String


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
                [ VU.textfieldString ServerImagesDirectory
                    model.config.serverImagesDirectory
                    False
                    "Images directory on the server"
                    "serverImagesDirectoryId"
                    "pure-input-1"
                , VU.textfieldString ServerPostsDirectory
                    model.config.serverPostsDirectory
                    False
                    "Posts directory on the server"
                    "serverPostsDirectoryId"
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
                , VU.textfieldString SshHost
                    model.config.sshHost
                    False
                    "SSH Host name"
                    "sshHostId"
                    "pure-input-1"
                , VU.textfieldString SshPort
                    model.config.sshPort
                    False
                    "SSH Port"
                    "sshPortId"
                    "pure-input-1"
                , VU.textfieldString SshUsername
                    model.config.sshUsername
                    False
                    "SSH User name"
                    "sshUserId"
                    "pure-input-1"
                , VU.textfieldStringML SshPrivateKey
                    model.config.sshPrivateKey
                    False
                    "SSH Private Key"
                    "sshPrivateKeyId"
                    "pure-input-1"
                    20
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
