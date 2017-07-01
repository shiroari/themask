port module Main exposing (..)

import Html exposing (Html)
import Platform.Cmd exposing (Cmd, none)
import Platform.Sub exposing (Sub, none)
import Model exposing (..)
import Message exposing (..)
import View exposing (..)
import Update exposing (..)

---

port onSave : String -> Cmd msg
port onDone : (String -> msg) -> Sub msg

---


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = View.view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( Model.model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    onDone Done


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Save ->
            ( model, onSave "" )

        _ ->
            Update.update msg model
