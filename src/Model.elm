module Model exposing (..)

import Material


type alias Model =
    { featureType : Feature
    , featureIndex : Int
    , featureIndexOver : Int
    , readyToSave : Bool
    , mask : Mask
    , mdl : Material.Model
    }


type Feature
    = Sex
    | Face
    | Hair
    | Eyes
    | Eyebrows
    | Nose
    | Mouth
    | Background
    | Undefined


type alias Mask =
    { sex : Int
    , face : Int
    , hair : Int
    , eyes : Int
    , eyebrows : Int
    , nose : Int
    , mouth : Int
    , background : Int
    }


model : Model
model =
    { featureType = Face
    , featureIndex = 0
    , featureIndexOver = -1
    , readyToSave = False
    , mask =
        { background = 0
        , sex = 0
        , face = 0
        , hair = 0
        , eyes = 4
        , eyebrows = 1
        , nose = 0
        , mouth = 1
        }
    , mdl = Material.model
    }


getFeatureIndex : Mask -> Feature -> Int
getFeatureIndex mask feature =
    case feature of
        Face ->
            mask.face

        Hair ->
            mask.hair

        Eyes ->
            mask.eyes

        Eyebrows ->
            mask.eyebrows

        Nose ->
            mask.nose

        Mouth ->
            mask.mouth

        Sex ->
            mask.sex

        Background ->
            mask.background

        Undefined ->
            0
