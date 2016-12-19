port module Ports exposing (..)


import Json.Decode as JD
import Json.Encode as JE


-- LOCAL IMPORTS

import Msg exposing (Msg)

-- Outgoing ports

port saveConfig : JE.Value -> Cmd msg

port saveAuthors : JE.Value -> Cmd msg

port delAuthor : JE.Value -> Cmd msg

port saveNextIds : JE.Value -> Cmd msg

port saveDefaultAuthor : JE.Value -> Cmd msg

port savePost : JE.Value -> Cmd msg

port delPost : JE.Value -> Cmd msg
