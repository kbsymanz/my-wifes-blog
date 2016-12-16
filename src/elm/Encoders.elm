module Encoders exposing (..)


import Json.Encode as JE



-- LOCAL IMPORTS

import Model exposing (Config, Author, NextIds, Id)



configToValue : Config -> JE.Value
configToValue cfg =
    JE.object
        [ ( "serverImagesPullCmd", JE.string cfg.serverImagesPullCmd )
        , ( "serverImagesPushCmd", JE.string cfg.serverImagesPushCmd )
        , ( "serverPostsPullCmd", JE.string cfg.serverPostsPullCmd )
        , ( "serverPostsPushCmd", JE.string cfg.serverPostsPushCmd )
        , ( "serverTriggerCmd", JE.string cfg.serverTriggerCmd )
        , ( "postsDirectory", JE.string cfg.postsDirectory )
        , ( "imagesDirectory", JE.string cfg.imagesDirectory )
        , ( "postCss", JE.string cfg.postCss )
        , ( "postTemplate", JE.string cfg.postTemplate )
        ]


authorsToValue : List Author -> JE.Value
authorsToValue authors =
    let
        toValue author =
            JE.object
                [ ( "id", JE.int author.id )
                , ( "firstname", JE.string author.firstname )
                , ( "lastname", JE.string author.lastname )
                , ( "email", JE.string author.email )
                ]
    in
        List.map toValue authors
            |> JE.list


nextIdsToValue : NextIds -> JE.Value
nextIdsToValue nextIds =
    JE.object
        [ ( "nextAuthorId", JE.int nextIds.nextAuthorId )
        , ( "nextPostId", JE.int nextIds.nextPostId )
        , ( "nextImageId", JE.int nextIds.nextImageId )
        ]


defaultAuthorToValue : Maybe Id -> JE.Value
defaultAuthorToValue defaultAuthor =
    case defaultAuthor of
        Just a ->
            JE.int a

        Nothing ->
            JE.null
