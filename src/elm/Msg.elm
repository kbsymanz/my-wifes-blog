module Msg exposing (Msg(..))

import Material
import Material.Snackbar as Snackbar
import Time exposing (Time)


type Msg
    = Tick Time
    | SetMessage String
    | ClearMessage
      -- Main screen selections.
    | SelectPost Int
    | SelectAuthor Int
    | SelectSettings
      -- Configuration settings.
    | ServerImagesPullCmd String
    | ServerImagesPushCmd String
    | ServerPostsPullCmd String
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
