module Main exposing (..)

import Dict exposing (Dict)
import Html
import Material
import Material.Layout as Layout
import Time


-- LOCAL IMPORTS

import Decoders
import Model exposing (..)
import Msg exposing (..)
import Update
import Utils as U
import View2 as View


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
        , Layout.sub0 Mdl
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , Layout.subs Mdl model.mdl
        ]
