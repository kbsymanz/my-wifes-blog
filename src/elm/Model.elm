module Model exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Json.Encode as JE
import Time exposing (Time)


type alias Model =
    { posts : Dict Id Post
    , masterImages : Dict Id MasterImage
    , derivedImages : Dict Id DerivedImage
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
    , images : List Id
    }


type alias NextIds =
    { nextAuthorId : Id
    , nextPostId : Id
    , nextImageId : Id
    }


{-| Image structure that application tracks and saves to disk.

  id: unique id across all images.

  originalFile: the full path to the file that the user selected.

  placeholdId: a short, unique within a post, id for the user to
  use in placing images.

  width: actual width, recorded for convenience of UI.

  height: actual height, recorded for convenience of UI.

  subtext: text that the user wants to display under the image.

  placement: Left, Center, or Right.

-}
type alias Image =
    { id : Id
    , originalFile : String
    , placeholderId : Id
    , width : Int
    , height : Int
    , subtext : String
    , placement : Placement
    }


{-| A master image represents a file that the user uploads
into the application. It is stored without change and is
considered immutable. Derived images are images that are
derived from master images. Master images cannot be displayed
in a post, only derived images can.

id : a unique id for the image.
sourceFile : the name of the file according to the id that the user originally uploaded.
width : the width of the original image.
height : the height of the original image.
-}
type alias MasterImage =
    { id : Id
    , sourceFile : String
    , width : Int
    , height : Int
    }


{-| A derived image represents an image that can be used within
the application for display in a post. A derived image is always
created using a master image as a source and applying one or more
operations upon it and then saving the resulting image as a file
that is named according to the id. A thumbnail for the derived image
is also always created and the file name stored.

id : a unique id for the image.
derivedFile : the name of the resulting file for the image, named according to the id.
thumbnailFile : the file for the thumbnail representation for this derived image.
masterImageId : the id of the master image.
width : the width of the derived image.
height : the height of the derived image.
rotation : the rotation of the derived image relative to the rotation of the master image.
-}
type alias DerivedImage =
    { id : Id
    , derivedFile : String
    , thumbnailFile : String
    , masterImageId : Id
    , width : Int
    , height : Int
    , rotation : Int
    }


{-| The view to be displayed in the content area.
-}
type ViewContent
    = ViewPost
    | ViewAuthor
    | ViewSettings
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

  serverImagesPushCmd: the OS command that pushes images to the server.

  serverPostsPushCmd: the OS command that pushes posts to the server.

  serverTriggerCmd: the OS command that pushes a file to the server
  that the server uses to know that it needs to regenerate the website.

  postsDirectory: the local directory where posts are stored.

  imagesDirectory: the local directory where images are stored.

  postCss: the css that makes the post and images of a post look
  correct in preview mode.

  postTemplate: the structure of the post file and variables that
  can be populated with actual data, e.g. title, date, author, etc.
-}
type alias Config =
    { serverImagesPushCmd : String
    , serverPostsPushCmd : String
    , serverTriggerCmd : String
    , postsDirectory : String
    , imagesDirectory : String
    , postCss : String
    , postTemplate : String
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
    { serverImagesPushCmd = ""
    , serverPostsPushCmd = ""
    , serverTriggerCmd = ""
    , postsDirectory = ""
    , imagesDirectory = ""
    , postCss = ""
    , postTemplate = ""
    }


model : Model
model =
    { posts = Dict.fromList [ ( emptyPost.id, emptyPost ) ]
    , masterImages = Dict.fromList [ ( emptyMasterImage.id, emptyMasterImage ) ]
    , derivedImages = Dict.fromList [ ( emptyDerivedImage.id, emptyDerivedImage ) ]
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


emptyMasterImage : MasterImage
emptyMasterImage =
    { id = -1
    , sourceFile = ""
    , width = 0
    , height = 0
    }


emptyDerivedImage : DerivedImage
emptyDerivedImage =
    { id = -2
    , derivedFile = ""
    , thumbnailFile = ""
    , masterImageId = -1
    , width = 0
    , height = 0
    , rotation = 0
    }


emptyAuthor : Author
emptyAuthor =
    { id = 0
    , firstname = "John"
    , lastname = "Doe"
    , email = "john.dow@example.com"
    }
