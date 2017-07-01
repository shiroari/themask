module Palette exposing (..)

import Model exposing (..)


type alias Palette =
    { name : String
    , required : Bool
    , path : String
    , presetSize : Int
    , size : Int
    }


getPalette : Feature -> Palette
getPalette x =
    case x of
        Sex ->
            { name = "Sex", required = True, path = "", presetSize = 0, size = 0 }

        Face ->
            { name = "Face", required = True, path = "/face", presetSize = 1, size = 25 }

        Hair ->
            { name = "Hair", required = False, path = "/hair", presetSize = 0, size = 20 }

        Eyes ->
            { name = "Eyes", required = False, path = "/eyes", presetSize = 0, size = 12 }

        Eyebrows ->
            { name = "Eyebrow", required = False, path = "/eyebrows", presetSize = 0, size = 20 }

        Nose ->
            { name = "Nose", required = False, path = "/nose", presetSize = 0, size = 20 }

        Mouth ->
            { name = "Mouth", required = False, path = "/mouth", presetSize = 0, size = 14 }

        Background ->
            { name = "Background", required = True, path = "", presetSize = 0, size = 23 }

        Undefined ->
            { name = "", required = False, path = "", presetSize = 0, size = 0 }


getFeatureFile : Int -> Palette -> String
getFeatureFile featureIndex featureInfo =
    "assets/svg" ++ featureInfo.path ++ "/" ++ (String.padLeft 3 '0' (toString (featureIndex + 1))) ++ ".svg"
