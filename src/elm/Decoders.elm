module Decoders exposing (..)

import Date
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE


-- LOCAL IMPORTS

import Model exposing (Post, Image, PublishPostResponse)
import Utils as U


imageDecoder : JD.Decoder Image
imageDecoder =
    JDP.decode Image
        |> JDP.required "id" JD.int
        |> JDP.required "masterFile" JD.string
        |> JDP.required "sourceFile" JD.string
        |> JDP.required "thumbnailFile" JD.string
        |> JDP.required "width" JD.int
        |> JDP.required "rotation" JD.int


decodeImage : JE.Value -> Result String Image
decodeImage payload =
    JD.decodeValue imageDecoder payload


postDecoder : JD.Decoder Post
postDecoder =
    let
        makePost id title cDate mDate body authorId tags status images =
            let
                cD =
                    Date.fromTime cDate

                mD =
                    Date.fromTime mDate

                st =
                    U.stringToPostStatus status
            in
                Post id title cD mD body authorId tags st images
    in
        JDP.decode makePost
            |> JDP.required "id" JD.int
            |> JDP.required "title" JD.string
            |> JDP.required "cDate" JD.float
            |> JDP.required "mDate" JD.float
            |> JDP.required "body" JD.string
            |> JDP.required "authorId" JD.int
            |> JDP.required "tags" JD.string
            |> JDP.required "status" JD.string
            |> JDP.required "images" (JD.list imageDecoder)


decodePosts : JE.Value -> List Post
decodePosts payload =
    case JD.decodeValue (JD.list postDecoder) payload of
        Ok posts ->
            posts

        _ ->
            []


publishPostResponse : JD.Decoder PublishPostResponse
publishPostResponse =
    JDP.decode PublishPostResponse
        |> JDP.required "id" JD.int
        |> JDP.required "success" JD.bool


decodePublishPostResponse : JE.Value -> Result String PublishPostResponse
decodePublishPostResponse payload =
    JD.decodeValue publishPostResponse payload
