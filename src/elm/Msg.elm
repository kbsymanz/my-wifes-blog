module Msg exposing (Msg(..))

import Time exposing (Time)

-- LOCAL IMPORTS

import Model exposing (Id, Image)


type Msg
    = Tick Time
    | SetMessage String
    | ClearMessage
      -- Main screen selections.
    | SelectPost Int
    | SelectAuthor Int
    | ViewPosts
    | EditPosts
    | EditAuthors
    | SelectSettings
      -- Configuration settings.
    | ServerImagesPushCmd String
    | ServerPostsPushCmd String
    | ServerTriggerCmd String
    | PostsDirectory String
    | ImagesDirectory String
    | PostCss String
    | PostTemplate String
    | SaveSettings
      -- Author.
    | AuthorFirstname String
    | AuthorLastname String
    | AuthorEmail String
    | SaveAuthors
    | NewAuthor
    | DelAuthor Int
    | SetDefaultAuthor (Maybe Int)
      -- Posts.
    | PostTitle String
    | PostBody String
    | PostTags String
    | SavePost
    | NewPost
    | DelPost Int
      -- Images
    | UploadImage
    | UpdateImage (Result String Image)
    | RemoveImage Id Int

