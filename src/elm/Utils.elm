module Utils exposing (..)

import Date exposing (Date)
import Dict exposing (Dict)
import Html exposing (Html)
import List.Extra as LE
import Material
import Material.Options as Options
import Material.Textfield as Textfield
import Regex as RX


-- LOCAL IMPORTS

import Model exposing (Model, Post, Id, Author, PostStatus(..))
import Msg exposing (..)


monthToString : Date.Month -> String
monthToString month =
    case month of
        Date.Jan ->
            "January"

        Date.Feb ->
            "February"

        Date.Mar ->
            "March"

        Date.Apr ->
            "April"

        Date.May ->
            "May"

        Date.Jun ->
            "June"

        Date.Jul ->
            "July"

        Date.Aug ->
            "August"

        Date.Sep ->
            "September"

        Date.Oct ->
            "October"

        Date.Nov ->
            "November"

        Date.Dec ->
            "December"

monthToNumString : Date.Month -> String
monthToNumString month =
    case month of
        Date.Jan ->
            "01"

        Date.Feb ->
            "02"

        Date.Mar ->
            "03"

        Date.Apr ->
            "04"

        Date.May ->
            "05"

        Date.Jun ->
            "06"

        Date.Jul ->
            "07"

        Date.Aug ->
            "08"

        Date.Sep ->
            "09"

        Date.Oct ->
            "10"

        Date.Nov ->
            "11"

        Date.Dec ->
            "12"


dayToString : Date.Day -> String
dayToString day =
    case day of
        Date.Mon ->
            "Monday"

        Date.Tue ->
            "Tuesday"

        Date.Wed ->
            "Wednesday"

        Date.Thu ->
            "Thursday"

        Date.Fri ->
            "Friday"

        Date.Sat ->
            "Saturday"

        Date.Sun ->
            "Sunday"


displayDate : Date -> String
displayDate date =
    (monthToString <| Date.month date)
        ++ " "
        ++ (toString <| Date.day date)
        ++ ", "
        ++ (toString <| Date.year date)


authorsFromList : List Author -> Dict Id Author
authorsFromList authors =
    Dict.fromList <| List.map (\a -> ( a.id, a )) authors


postStatusToString : PostStatus -> String
postStatusToString status =
    case status of
        NotPublished ->
            "NotPublished"

        Published ->
            "Published"

        PublishedButChanged ->
            "PublishedButChanged"


stringToPostStatus : String -> PostStatus
stringToPostStatus str =
    case str of
        "NotPublished" ->
            NotPublished

        "Published" ->
            Published

        "PublishedButChanged" ->
            PublishedButChanged

        _ ->
            let
                _ =
                    Debug.log "stringToPostStatus" <| "Error: unknown value passed: " ++ str
            in
                Published


{-| Assumes a forward slash for the directory/file
separator.
-}
basepathPlusFile : String -> String -> String
basepathPlusFile dir file =
    let
        fullpath =
            case String.endsWith "/" dir of
                True ->
                    dir ++ file

                False ->
                    dir ++ "/" ++ file
    in
        fullpath


replaceImages : Post -> String -> Model -> String
replaceImages post imagesDirectory model =
    let
        getSourceFile : String -> Maybe String
        getSourceFile idx =
            let
                index =
                    case String.toInt idx of
                        Ok i ->
                            i

                        Err s ->
                            -100
            in
                case
                    LE.getAt index post.images
                of
                    Just i ->
                        Just i.sourceFile

                    Nothing ->
                        Nothing

        getImg : String -> String
        getImg idx =
            case getSourceFile idx of
                Just sf ->
                    "<p><img src='"
                        ++ (basepathPlusFile imagesDirectory sf)
                        ++ "'></img></p>"

                Nothing ->
                    "<pre>Sorry, image " ++ idx ++ " was not found. Did you add it to the post?</pre>"
    in
        RX.replace RX.All
            (RX.regex "<<(.*)>>")
            (\match ->
                let
                    imgElement =
                        case List.head match.submatches of
                            Just idx ->
                                case idx of
                                    Just index ->
                                        getImg index

                                    Nothing ->
                                        ""

                            Nothing ->
                                ""
                in
                    imgElement
            )
            post.body


