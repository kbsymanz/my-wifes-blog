module Update exposing (update)

import Date exposing (Date)
import Dict exposing (Dict)
import List.Extra as LE
import Regex as RX
import Task


-- LOCAL IMPORTS

import Encoders
import Model
    exposing
        ( Model
        , Author
        , Post
        , Id
        , Image
        , NextIds
        , PublishPost
        , ViewContent(..)
        , PostStatus(..)
        )
import Msg exposing (Msg(..))
import Ports
import Utils as U


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetMessage msg ->
            { model | userMessage = Just msg, userMessageTime = model.currentTime } ! []

        ClearMessage ->
            let
                -- Make sure some time has passed before clearing a message.
                newModel =
                    if model.currentTime == model.userMessageTime then
                        model
                    else
                        { model | userMessage = Nothing, userMessageTime = 0 }
            in
                newModel ! []

        Tick time ->
            { model | currentTime = time } ! []

        ViewPosts ->
            { model | viewContent = ViewPost } ! []

        EditPosts ->
            { model | viewContent = EditPost } ! []

        EditAuthors ->
            { model | viewContent = EditAuthor } ! []

        SelectPost id ->
            let
                viewContent =
                    case model.viewContent of
                        ViewPost ->
                            ViewPost

                        _ ->
                            EditPost
            in
                { model | currentPost = id, viewContent = viewContent } ! [ clearMessage ]

        SelectAuthor id ->
            let
                author =
                    Dict.get id model.authors

                newModel =
                    case author of
                        Just a ->
                            { model | viewContent = EditAuthor, currentAuthor = a.id }

                        Nothing ->
                            model
            in
                newModel ! [ clearMessage ]

        SelectSettings ->
            { model | viewContent = EditSettings } ! [ clearMessage ]

        ServerImagesDirectory dir ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverImagesDirectory = dir }
            in
                { model | config = newConfig } ! []

        ServerPostsDirectory dir ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | serverPostsDirectory = dir }
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

        SshHost host ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | sshHost = host }
            in
                { model | config = newConfig } ! []

        SshPort sshPort ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | sshPort = sshPort }
            in
                { model | config = newConfig } ! []

        SshUsername name ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | sshUsername = name }
            in
                { model | config = newConfig } ! []

        SshPrivateKey pk ->
            let
                newConfig =
                    model.config
                        |> \c -> { c | sshPrivateKey = pk }
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
                        ( deleteAuthor id model, Cmd.batch [ Ports.delAuthor <| Encoders.idToValue id ] )
                    else
                        ( model, setMessage "Sorry, the author cannot be deleted while still owning posts." )
            in
                newModel ! [ newCmd, Task.perform SelectAuthor (Task.succeed <| Maybe.withDefault 0 firstOtherAuthorId) ]

        SetDefaultAuthor maybeId ->
            { model | defaultAuthor = maybeId } ! [ Ports.saveDefaultAuthor <| Encoders.defaultAuthorToValue maybeId ]

        PostTitle title ->
            let
                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    Just { p | title = title, mDate = Date.fromTime model.currentTime }

                                Nothing ->
                                    post
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []

        PostBody body ->
            let
                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    Just { p | body = body, mDate = Date.fromTime model.currentTime }

                                Nothing ->
                                    post
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []

        PostTags tags ->
            let
                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    Just { p | tags = tags, mDate = Date.fromTime model.currentTime }

                                Nothing ->
                                    post
                        )
                        model.posts
            in
                { model | posts = newPosts } ! []

        SavePost ->
            let
                -- Get the default author id or zero if not found.
                defaultAuthorId =
                    case model.defaultAuthor of
                        Just id ->
                            id

                        Nothing ->
                            0

                -- Updates the model with the default author id.
                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    Just { p | authorId = defaultAuthorId }

                                Nothing ->
                                    post
                        )
                        model.posts

                -- If we have a post (we should) then save to localStorage.
                newCmd =
                    case Dict.get model.currentPost newPosts of
                        Just p ->
                            Ports.savePost <| Encoders.postToValue p

                        Nothing ->
                            Cmd.none
            in
                -- Save to state and disk.
                { model | posts = newPosts } ! [ newCmd ]

        NewPost ->
            let
                ( id, author ) =
                    ( model.nextIds.nextPostId, Maybe.withDefault 0 model.defaultAuthor )

                currDate =
                    Date.fromTime model.currentTime

                newPost =
                    Post id "" currDate currDate "" author "" NotPublished []

                posts =
                    Dict.insert id newPost model.posts

                nextIds =
                    NextIds model.nextIds.nextAuthorId (id + 1) model.nextIds.nextImageId

                ( updatedModel, updatedCmd ) =
                    update (SelectPost id) model
            in
                { updatedModel | posts = posts, nextIds = nextIds, viewContent = EditPost }
                    ! [ saveNextIdsCmd nextIds, updatedCmd ]

        DelPost id ->
            let
                newPosts =
                    Dict.remove id model.posts

                newCurrentPost =
                    case
                        Dict.keys newPosts
                            |> List.reverse
                            |> LE.dropWhile (\p -> p > id)
                            |> List.head
                    of
                        Just i ->
                            i

                        Nothing ->
                            0
            in
                { model | posts = newPosts, currentPost = newCurrentPost }
                    ! [ Ports.delPost <| Encoders.idToValue id ]

        PublishPostMsg id ->
            let
                publishPost =
                    genPublishPost id model

                newCmds =
                    case publishPost of
                        Just p ->
                            [ Ports.publishPost <| Encoders.encodePublishPost p
                            , setMessage "Sending post to server...it takes a while."
                            ]

                        Nothing ->
                            [ Cmd.none ]
            in
                { model | isSyncing = True } ! newCmds

        PublishPostResponseMsg publishPostResponse ->
            let
                _ =
                    Debug.log "PublishPostResponse" <| toString publishPostResponse

                newCmd =
                    case publishPostResponse of
                        Ok ppr ->
                            if ppr.success then
                                setMessage
                                    <| "Successfully published post "
                                        ++ (toString ppr.id)
                                        ++ " to the server."
                            else
                                setMessage
                                    <| "There was an error publishing post "
                                        ++ (toString ppr.id)
                                        ++ " to the server."
                        Err str ->
                            setMessage
                                <| "Error encountered: "
                                    ++ str
            in
                { model | isSyncing = False } ! [ newCmd ]

        UploadImage ->
            let
                id =
                    model.nextIds.nextImageId

                nextIds =
                    NextIds model.nextIds.nextAuthorId model.nextIds.nextPostId (id + 1)

                image =
                    Image id "" "" "" 0 0

                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    Just { p | images = p.images ++ [ image ] }

                                Nothing ->
                                    post
                        )
                        model.posts
            in
                ( { model | posts = newPosts, nextIds = nextIds }
                , Cmd.batch [ uploadImageCmd id, saveNextIdsCmd nextIds ]
                )

        UpdateImage img ->
            let
                newPosts =
                    case img of
                        Ok image ->
                            Dict.update model.currentPost
                                (\post ->
                                    case post of
                                        Just p ->
                                            let
                                                images =
                                                    List.map
                                                        (\i ->
                                                            if i.id == image.id then
                                                                image
                                                            else
                                                                i
                                                        )
                                                        p.images
                                            in
                                                Just { p | images = images }

                                        Nothing ->
                                            post
                                )
                                model.posts

                        Err str ->
                            model.posts
            in
                ( { model | posts = newPosts }, Task.perform (always SavePost) (Task.succeed True) )

        RemoveImage postId idx ->
            let
                -- TODO: handle references to images in post.body.
                newPosts =
                    Dict.update model.currentPost
                        (\post ->
                            case post of
                                Just p ->
                                    let
                                        images =
                                            List.take idx p.images
                                                ++ List.drop (idx + 1) p.images
                                    in
                                        Just { p | images = images }

                                Nothing ->
                                    post
                        )
                        model.posts
            in
                ( { model | posts = newPosts }, Task.perform (always SavePost) (Task.succeed True) )


clearMessage : Cmd Msg
clearMessage =
    Task.perform (\_ -> ClearMessage) (Task.succeed True)


setMessage : String -> Cmd Msg
setMessage msg =
    Task.perform SetMessage (Task.succeed msg)


saveNextIdsCmd : NextIds -> Cmd msg
saveNextIdsCmd nextIds =
    Ports.saveNextIds <| Encoders.nextIdsToValue nextIds


uploadImageCmd : Int -> Cmd msg
uploadImageCmd id =
    Ports.uploadImage <| Encoders.imageIdFilepathToValue id


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
    Dict.filter (\_ post -> post.authorId == id) model.posts
        |> Dict.size
        |> flip (>=) 1


getHeader : Post -> Model -> String
getHeader post model =
    let
        -- YYYY-MM-DD as a String
        getDate d =
            (toString <| Date.year d)
                ++ "-"
                ++ (U.monthToNumString <| Date.month d)
                ++ "-"
                ++ (String.padLeft 2 '0' <| toString <| Date.day d)
    in
        "---\n"
            ++ "title: "
            ++ post.title
            ++ "\n"
            ++ "publishDate: "
            ++ (getDate post.cDate)
            ++ "\n"
            ++ "modifiedDate: "
            ++ (getDate post.mDate)
            ++ "\n"
            ++ "author: "
            ++ (getAuthorName post model)
            ++ "\n"
            ++ "collection: posts\n"
            ++ "template: post.jade\n"
            ++ "---\n\n"


getAuthorName : Post -> Model -> String
getAuthorName post model =
    case Dict.get post.authorId model.authors of
        Just a ->
            a.firstname ++ " " ++ a.lastname

        Nothing ->
            ""


genPublishPost : Id -> Model -> Maybe PublishPost
genPublishPost id model =
    case Dict.get id model.posts of
        Just p ->
            let
                header =
                    getHeader p model
            in
                Just <|
                    PublishPost id
                        (header ++ U.replaceImages p "/images" model)
                        (List.map .sourceFile p.images)
                        model.config

        Nothing ->
            Nothing
