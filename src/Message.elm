module Message exposing (..)

import Material
import Model exposing (..)


type Msg
    = Mdl (Material.Msg Msg)
    | Select Int
    | SelectOver Int
    | Mode Feature
    | ReadyToSave Bool
    | Done String
    | Save
