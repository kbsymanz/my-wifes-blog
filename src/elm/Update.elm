module Update exposing (update)

import Date
import Dict exposing (Dict)
import Material
import Material.Snackbar as Snackbar
import List.Extra as LE
import List.Zipper as Zipper
import Task


-- LOCAL IMPORTS

import Encoders
import Model exposing (Model, Author, Id, NextIds, ViewContent(..))
import Msg exposing (Msg(..))
import Ports


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl message ->
            Material.update message model

        Toast message ->
            let
                ( sbModel, sbCmd ) =
                    Snackbar.update message model.toast
            in
                { model | toast = sbModel } ! [ Cmd.map Toast sbCmd ]

        Tick time ->
            { model | currentTime = time } ! []

        SelectPost id ->
            let
                newPosts =
                    case Zipper.find (\p -> p.id == id) (Zipper.first model.posts) of
                        Just posts ->
                            posts

                        Nothing ->
                            model.posts
            in
                { model | posts = newPosts, viewContent = ViewPost } ! []

        SelectAuthor id ->
            let
                author =
                    Dict.get id model.authors

                newModel =
                    case author of
                        Just a ->
                            { model | viewContent = ViewAuthor, currentAuthor = a.id }

                        Nothing ->
                            model
            in
                newModel ! []

        SelectSettings ->
            { model | viewContent = ViewSettings } ! []

        ServerImagesPullCmd cmd ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverImagesPullCmd = cmd }
            in
                { model | config = newConfig } ! []

        ServerImagesPushCmd cmd ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverImagesPushCmd = cmd }
            in
                { model | config = newConfig } ! []

        ServerPostsPullCmd cmd ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverPostsPullCmd = cmd }
            in
                { model | config = newConfig } ! []

        ServerPostsPushCmd cmd ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverPostsPushCmd = cmd }
            in
                { model | config = newConfig } ! []

        ServerTriggerCmd cmd ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverTriggerCmd = cmd }
            in
                { model | config = newConfig } ! []

        PostsDirectory dir ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | postsDirectory = dir }
            in
                { model | config = newConfig } ! []

        ImagesDirectory dir ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | imagesDirectory = dir }
            in
                { model | config = newConfig } ! []

        PostCss css ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | postCss = css }
            in
                { model | config = newConfig } ! []

        PostTemplate template ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | postTemplate = template }
            in
                { model | config = newConfig } ! []

        SaveSettings ->
            model ! [ Ports.saveConfig <| Encoders.configToValue model.config ]

        AuthorFirstname first ->
            let
                newModel =
                    updateAuthorFirst model.currentAuthor first model
            in
                newModel ! []

        AuthorLastname last ->
            let
                newModel =
                    updateAuthorLast model.currentAuthor last model
            in
                newModel ! []

        AuthorEmail email ->
            let
                newModel =
                    updateAuthorEmail model.currentAuthor email model
            in
                newModel ! []

        SaveAuthors ->
            model ! [ Ports.saveAuthors <| Encoders.authorsToValue <| Dict.values model.authors ]

        NewAuthor ->
            let
                id =
                    model.nextIds.nextAuthorId

                authors =
                    Dict.insert id (Author id "" "" "") model.authors

                nextIds =
                    NextIds (id + 1) model.nextIds.nextPostId model.nextIds.nextImageId

                model1 =
                    { model | authors = authors, nextIds = nextIds }

                ( model2, cmd2 ) =
                    update (SelectAuthor id) model1
            in
                ( model2, Cmd.batch [ cmd2, saveNextIdsCmd nextIds ] )

        DelAuthor id ->
            let
                isReferenced =
                    authorInPosts id model

                firstOtherAuthorId =
                    Dict.filter (\k v -> k /= id) model.authors
                        |> Dict.values
                        |> List.head
                        |> Maybe.map .id

                ( newModel, newCmd ) =
                    if not isReferenced then
                        ( deleteAuthor id model, Cmd.none )
                    else
                        addToast "Sorry, you cannot delete this author because this author still owns posts." model
            in
                case ( firstOtherAuthorId, isReferenced ) of
                    ( Just i, False ) ->
                        update (SelectAuthor i) newModel

                    _ ->
                        newModel ! [ newCmd ]

        SetDefaultAuthor maybeId ->
            { model | defaultAuthor = maybeId } ! [ Ports.saveDefaultAuthor <| Encoders.defaultAuthorToValue maybeId ]

        PostTitle title ->
            let
                newPosts =
                    Zipper.mapCurrent
                        (\p ->
                            { p
                                | title = title
                                , mDate = Date.fromTime model.currentTime
                            }
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []

        PostBody body ->
            let
                newPosts =
                    Zipper.mapCurrent
                        (\p ->
                            { p
                                | body = body
                                , mDate = Date.fromTime model.currentTime
                            }
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []

        PostTags tags ->
            let
                newPosts =
                    Zipper.mapCurrent
                        (\p ->
                            { p
                                | tags = tags
                                , mDate = Date.fromTime model.currentTime
                            }
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []



addToast : String -> Model -> ( Model, Cmd Msg )
addToast msg model =
    let
        sbContent =
            Snackbar.toast () msg

        ( sbModel, sbCmd ) =
            Snackbar.add sbContent model.toast
    in
        ( { model | toast = sbModel }, Cmd.map Toast sbCmd )


saveNextIdsCmd : NextIds -> Cmd msg
saveNextIdsCmd nextIds =
    Ports.saveNextIds <| Encoders.nextIdsToValue nextIds


updateAuthorFirst : Id -> String -> Model -> Model
updateAuthorFirst id first model =
    let
        authors =
            Dict.update id
                (\v ->
                    case v of
                        Just a ->
                            Just { a | firstname = first }

                        Nothing ->
                            Nothing
                )
                model.authors
    in
        { model | authors = authors }


updateAuthorLast : Id -> String -> Model -> Model
updateAuthorLast id last model =
    let
        authors =
            Dict.update id
                (\v ->
                    case v of
                        Just a ->
                            Just { a | lastname = last }

                        Nothing ->
                            Nothing
                )
                model.authors
    in
        { model | authors = authors }


updateAuthorEmail : Id -> String -> Model -> Model
updateAuthorEmail id email model =
    let
        authors =
            Dict.update id
                (\v ->
                    case v of
                        Just a ->
                            Just { a | email = email }

                        Nothing ->
                            Nothing
                )
                model.authors
    in
        { model | authors = authors }


deleteAuthor : Id -> Model -> Model
deleteAuthor id model =
    let
        newAuthors =
            Dict.remove id model.authors
    in
        { model | authors = newAuthors }


authorInPosts : Id -> Model -> Bool
authorInPosts id model =
    Zipper.toList model.posts
        |> List.any (\p -> p.authorId == id)
