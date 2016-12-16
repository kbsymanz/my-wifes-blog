module Model exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Material
import Material.Snackbar as Snackbar
import Time exposing (Time)
import List.Zipper as Zipper exposing (Zipper)


type alias Model =
    { posts : Zipper Post
    , images : Zipper Image
    , authors : Dict Id Author
    , currentAuthor : Id
    , viewContent : ViewContent
    , isSyncing : Bool
    , config : Config
    , mdl : Material.Model
    , toast : Snackbar.Model ()
    , currentTime : Time
    , nextIds : NextIds
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
    , state : PostState
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


{-| The view to be displayed in the content area.
-}
type ViewContent
    = ViewPost
    | ViewAuthor
    | ViewSettings

type Placement
    = Left
    | Center
    | Right


{-| Are we editing this post or viewing it?
-}
type PostState
    = Editing
    | Viewing


{-| Is this post published or not?
-}
type PostStatus
    = NotPublished
    | Published


{-| What is passed into the Elm app at application start.
-}
type alias Flags =
    { config : Config
    , authors : List Author
    , nextIds : NextIds
    }

{-| Configuration settings. Allow the user to control them.
These settings will need to be saved in the app database.

  serverImagesPullCmd: the OS command that pulls images from the server.

  serverImagesPushCmd: the OS command that pushes images to the server.

  serverPostsPullCmd: the OS command that pulls posts from the server.

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
    { serverImagesPullCmd : String
    , serverImagesPushCmd : String
    , serverPostsPullCmd : String
    , serverPostsPushCmd: String
    , serverTriggerCmd : String
    , postsDirectory : String
    , imagesDirectory: String
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


type alias Mdl =
    Material.Model


config : Config
config =
    { serverImagesPullCmd = ""
    , serverImagesPushCmd = ""
    , serverPostsPullCmd = ""
    , serverPostsPushCmd = ""
    , serverTriggerCmd = ""
    , postsDirectory = ""
    , imagesDirectory = ""
    , postCss = ""
    , postTemplate = ""
    }


model : Model
model =
    { posts =
        case Zipper.fromList posts of
            Just p ->
                p

            Nothing ->
                Zipper.singleton emptyPost
    , images =
        case Zipper.fromList images of
            Just i ->
                i

            Nothing ->
                Zipper.singleton emptyImage
    , authors = Dict.fromList <| List.map (\a -> (a.id, a)) authors
    , currentAuthor = 0
    , viewContent = ViewPost
    , isSyncing = False
    , config = config
    , mdl = Material.model
    , toast = Snackbar.model
    , currentTime = 0
    , nextIds = nextIds
    }

nextIds : NextIds
nextIds =
    { nextAuthorId = 0
    , nextPostId = 0
    , nextImageId = 0
    }

posts : List Post
posts =
    [ { id = -1
      , title = "This is a test post"
      , cDate = Date.fromTime 0
      , mDate = Date.fromTime 0
      , body = "If this had been an actual post ..."
      , authorId = 0
      , tags = ""
      , status = NotPublished
      , state = Viewing
      , images = []
      }
    , { id = -2
      , title = "This is another test post"
      , cDate = Date.fromTime (1000 * 60 * 60 * 24)
      , mDate = Date.fromTime (1000 * 60 * 60 * 24)
      , body = "If this had been an actual post ..."
      , authorId = 1
      , tags = ""
      , status = NotPublished
      , state = Viewing
      , images = []
      }
    ]

images : List Image
images =
    [ { id = 1
      , originalFile  = ""
      , placeholderId  = 1
      , width  = 1
      , height  = 1
      , subtext  = ""
      , placement = Center
      }
    , { id = 2
      , originalFile  = ""
      , placeholderId  = 2
      , width  = 1
      , height  = 1
      , subtext  = ""
      , placement = Center
      }
    ]

emptyPost : Post
emptyPost =
    { id = -100
    , title = ""
    , cDate = Date.fromTime 0
    , mDate = Date.fromTime 0
    , body = ""
    , authorId = -1
    , tags = ""
    , status = NotPublished
    , state = Viewing
    , images = []
    }

emptyImage : Image
emptyImage =
    { id = 0
    , originalFile  = ""
    , placeholderId  = 0
    , width  = 1
    , height  = 1
    , subtext  = ""
    , placement = Center
    }

authors : List Author
authors =
    [ author
    , { id = 0, firstname = "Beth", lastname = "Symanzik", email = "beth@kbsymanzik.org" }
    , { id = 1, firstname = "Kurt", lastname = "Symanzik", email = "kurt@kbsymanzik.org" }
    ]


author : Author
author =
    { id = -1
    , firstname = "John"
    , lastname = "Doe"
    , email = "john.dow@example.com"
    }
