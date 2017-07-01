module Update exposing (update)

import Material
import Model exposing (..)
import Message exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Select featureIndex_ ->
            let
                mask_ =
                    newMask featureIndex_ model
            in
                { model | featureIndex = featureIndex_, mask = mask_ } ! []

        SelectOver featureIndex_ ->
            { model | featureIndexOver = featureIndex_ } ! []

        Mode feature ->
            { model | featureType = feature, featureIndex = 0 } ! []

        ReadyToSave msg_ ->
            { model | readyToSave = msg_ } ! []

        Save ->
            model ! []

        Done _ ->
            model ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model


newMask : Int -> Model -> Mask
newMask featureIndex model =
    let
        mask =
            model.mask

        feature =
            model.featureType
    in
        case feature of
            Face ->
                { mask | face = featureIndex }

            Hair ->
                { mask | hair = featureIndex }

            Eyes ->
                { mask | eyes = featureIndex }

            Eyebrows ->
                { mask | eyebrows = featureIndex }

            Nose ->
                { mask | nose = featureIndex }

            Mouth ->
                { mask | mouth = featureIndex }

            Background ->
                { mask | background = featureIndex }

            Sex ->
                { mask | sex = featureIndex }

            Undefined ->
                { mask | mouth = featureIndex }
