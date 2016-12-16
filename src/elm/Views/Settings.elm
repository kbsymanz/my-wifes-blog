module Views.Settings exposing (view)

import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Material
import Material.Button as Button
import Material.Grid as Grid
import Material.Options as Options
import Material.Textfield as Textfield
import Material.Typography as Typo


-- LOCAL IMPORTS

import Model exposing (..)
import Msg exposing (..)
import Utils as U


settingsContext : Int
settingsContext =
    1000



settingsForm : Model -> Html Msg
settingsForm model =
    Html.div []
        [ U.textfieldString model.mdl
            [ settingsContext, 0 ]
            "Command to pull images from the server"
            model.config.serverImagesPullCmd
            (\c -> ServerImagesPullCmd c)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 1 ]
            "Command to push images to the server"
            model.config.serverImagesPushCmd
            (\c -> ServerImagesPushCmd c)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 2 ]
            "Command to pull posts from the server"
            model.config.serverPostsPullCmd
            (\c -> ServerPostsPullCmd c)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 3 ]
            "Command to push posts to the server"
            model.config.serverPostsPushCmd
            (\c -> ServerPostsPushCmd c)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 4 ]
            "Server trigger command"
            model.config.serverTriggerCmd
            (\c -> ServerTriggerCmd c)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 5 ]
            "Local posts directory"
            model.config.postsDirectory
            (\d -> PostsDirectory d)
        , Html.br [] []
        , U.textfieldString model.mdl
            [ settingsContext, 6 ]
            "Local images directory"
            model.config.imagesDirectory
            (\d -> ImagesDirectory d)
        , Html.br [] []
        , U.textfieldStringML model.mdl
            [ settingsContext, 7 ]
            "CSS for each post"
            model.config.postCss
            (\c -> PostCss c)
            10
        , Html.br [] []
        , U.textfieldStringML model.mdl
            [ settingsContext, 8 ]
            "File template for each post"
            model.config.postTemplate
            (\t -> PostTemplate t)
            10
        ]

saveBtn : Model -> Html Msg
saveBtn model =
    Button.render Mdl
        [ settingsContext, 100 ]
        model.mdl
        [ Button.raised
        , Button.ripple
        , Button.onClick SaveSettings
        , Options.css "margin-left" "30px"
        ]
        [ Html.text "Save" ]


view : Model -> Html Msg
view model =
    Grid.grid []
        [ Grid.cell
            [ Grid.size Grid.Desktop 12
            , Grid.size Grid.Tablet 8
            , Grid.size Grid.Phone 4
            ]
            [ Options.styled Html.p
                [ Typo.display2 ]
                [ Html.span []
                    [ Html.text "Settings"
                    , saveBtn model
                    ]
                ]
            , settingsForm model
            ]
        ]
