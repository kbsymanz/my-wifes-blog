module Main exposing (..)

import Dict exposing (Dict)
import Html
import Time


-- LOCAL IMPORTS

import Decoders
import Model exposing (..)
import Msg exposing (..)
import Ports
import Update
import Utils as U
import View as View


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = Update.update
        , subscriptions = subscriptions
        , view = View.view
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        theModel =
            Model.model
    in
        ( { theModel
            | config = flags.config
            , authors = U.authorsFromList flags.authors
            , nextIds = flags.nextIds
            , defaultAuthor = flags.defaultAuthor
            , posts = Decoders.decodePosts flags.posts
                |> List.map (\p -> (p.id, p))
                |> Dict.fromList
          }
        , Cmd.none
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , Ports.updateImage Decoders.decodeImage
            |> Sub.map UpdateImage
        , Ports.publishPostResponse Decoders.decodePublishPostResponse
            |> Sub.map Msg.PublishPostResponseMsg
        ]
