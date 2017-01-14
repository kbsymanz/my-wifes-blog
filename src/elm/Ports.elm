port module Ports exposing (..)

import Json.Decode as JD
import Json.Encode as JE


-- LOCAL IMPORTS

import Msg exposing (Msg)
import Model exposing (Image)


-- Incoming ports


port updateImage : (JD.Value -> msg) -> Sub msg


port publishPostResponse : (JD.Value -> msg) -> Sub msg



-- Outgoing ports


port saveConfig : JE.Value -> Cmd msg


port saveAuthors : JE.Value -> Cmd msg


port delAuthor : JE.Value -> Cmd msg


port saveNextIds : JE.Value -> Cmd msg


port saveDefaultAuthor : JE.Value -> Cmd msg


port savePost : JE.Value -> Cmd msg


port delPost : JE.Value -> Cmd msg


port uploadImage : JE.Value -> Cmd msg


port publishPost : JE.Value -> Cmd msg
