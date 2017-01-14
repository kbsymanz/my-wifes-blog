module Model exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Json.Encode as JE
import Time exposing (Time)


type alias Model =
    { posts : Dict Id Post
    , authors : Dict Id Author
    , currentAuthor : Id
    , currentPost : Id
    , defaultAuthor : Maybe Id
    , viewContent : ViewContent
    , isSyncing : Bool
    , config : Config
    , currentTime : Time
    , nextIds : NextIds
    , userMessage : Maybe String
    , userMessageTime : Time
    }


type alias Post =
    { id : Id
    , title : String
    , cDate : Date
    , mDate : Date
    , body : String
    , authorId : Id
    , tags : String
    , status : PostStatus
    , images : List Image
    }


type alias NextIds =
    { nextAuthorId : Id
    , nextPostId : Id
    , nextImageId : Id
    }


{-| Represents an image in a post. Each image across all posts has a
unique id. The original image is saved as the masterFile and is not
changed. Changes are applied to the sourceFile and repeated changes
are allowed. The thumbnailFile is also created from the masterFile and
is recreated whenever rotation is applied.

id : a unique id for the image.
masterFile : the name of the file that the user originally uploaded, named by id.
sourceFile : the name of the file that was adjusted from the original, named by id.
thumbnailFile : the name of the file thumbnail file according to the id.
width : the width of the original image. We don't care about the height.
rotation : the rotation from the original file that is applied.
-}
type alias Image =
    { id : Id
    , masterFile : String
    , sourceFile : String
    , thumbnailFile : String
    , width : Int
    , rotation : Int
    }


{-| The view to be displayed in the content area.
-}
type ViewContent
    = EditPost
    | ViewPost
    | EditAuthor
    | EditSettings
    | ViewNothing


type Placement
    = Left
    | Center
    | Right


{-| Is this post published or not?
-}
type PostStatus
    = NotPublished
    | Published
    | PublishedButChanged


{-| What is passed into the Elm app at application start.
-}
type alias Flags =
    { config : Config
    , authors : List Author
    , nextIds : NextIds
    , defaultAuthor : Maybe Id
    , posts : JE.Value
    }


{-| Configuration settings. Allow the user to control them.
These settings will need to be saved in the app database.

  serverImagesDirectory: the remote directory where images are stored.

  serverPostsDirectory: the remote directory where posts are stored.

  serverTriggerCmd: the OS command that pushes a file to the server
  that the server uses to know that it needs to regenerate the website.

  postsDirectory: the local directory where posts are stored.

  imagesDirectory: the local directory where images are stored.

  postCss: the css that makes the post and images of a post look
  correct in preview mode.

  postTemplate: the structure of the post file and variables that
  can be populated with actual data, e.g. title, date, author, etc.

  sshHost: the SSH host name

  sshPort: the SSH port

  sshUsername: the SSH username

  sshPrivateKey: the SSH private key. This is the key itself, not the file name.
-}
type alias Config =
    { serverImagesDirectory : String
    , serverPostsDirectory : String
    , serverTriggerCmd : String
    , postsDirectory : String
    , imagesDirectory : String
    , postCss : String
    , postTemplate : String
    , sshHost : String
    , sshPort : String
    , sshUsername : String
    , sshPrivateKey : String
    }


type alias Author =
    { id : Id
    , firstname : String
    , lastname : String
    , email : String
    }


type alias Id =
    Int


config : Config
config =
    { serverImagesDirectory = ""
    , serverPostsDirectory = ""
    , serverTriggerCmd = ""
    , postsDirectory = ""
    , imagesDirectory = ""
    , postCss = ""
    , postTemplate = ""
    , sshHost = ""
    , sshPort = "22"
    , sshUsername = ""
    , sshPrivateKey = ""
    }


model : Model
model =
    { posts = Dict.fromList [ ( emptyPost.id, emptyPost ) ]
    , authors = Dict.fromList [ ( emptyAuthor.id, emptyAuthor ) ]
    , currentAuthor = 0
    , currentPost = 0
    , defaultAuthor = Nothing
    , viewContent = ViewNothing
    , isSyncing = False
    , config = config
    , currentTime = 0
    , nextIds = nextIds
    , userMessage = Just "Select either a post or author on the left, or settings in the upper right."
    , userMessageTime = 0
    }


nextIds : NextIds
nextIds =
    { nextAuthorId = 0
    , nextPostId = 0
    , nextImageId = 0
    }


emptyPost : Post
emptyPost =
    { id = 0
    , title = ""
    , cDate = Date.fromTime 0
    , mDate = Date.fromTime 0
    , body = ""
    , authorId = -1
    , tags = ""
    , status = NotPublished
    , images = []
    }


emptyImage : Image
emptyImage =
    { id = -1
    , masterFile = ""
    , sourceFile = ""
    , thumbnailFile = ""
    , width = 0
    , rotation = 0
    }


emptyAuthor : Author
emptyAuthor =
    { id = 0
    , firstname = "John"
    , lastname = "Doe"
    , email = "john.dow@example.com"
    }
