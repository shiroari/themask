import Platform.Cmd exposing (Cmd, none)

import Html exposing (Html, div)
import Html.Events
import Html.Attributes 

import Svg exposing (..)
import Svg.Events
import Svg.Attributes exposing (..)

import Material.Card as Card 
import Material.Button as Button 
import Material.Icon as Icon
import Material.Elevation as Elevation
import Material.Color as Color
import Material.Options as Options exposing (cs, css)
import Material
import Material.Typography as Typography
import Material.Tabs as Tabs
import Material.Helpers exposing (map1st, map2nd)

-- MODEL

type alias Mask = {
  sex: Int,
  face: Int,
  hair: Int,
  eyes: Int,
  eyebrows: Int,
  nose: Int,
  mouth: Int  
}

type alias Model = {
  featureType: Int,
  featureIndex: Int,
  featureIndexOver: Int,
  mask: Mask,
  mdl : Material.Model
}

model : Model
model = { 
    featureType = 0,
    featureIndex = 0,
    featureIndexOver = 0,
    mask = { 
      sex = 0, 
      face = 0, 
      hair = 0, 
      eyes = 0, 
      eyebrows = 0,
      nose = 0,
      mouth = 0
      },
    mdl = Material.model 
  }

-- UPDATE

type Msg
  = Mdl (Material.Msg Msg)
  | Select (Int)
  | SelectOver (Int)
  | Mode (Int)

newMask: Int -> Model -> Mask
newMask featureIndex model =
  let 
    mask = model.mask 
  in
  case model.featureType of
    0 -> { mask | face = featureIndex }
    1 -> { mask | hair = featureIndex }
    2 -> { mask | eyes = featureIndex }
    3 -> { mask | eyebrows = featureIndex }
    4 -> { mask | nose = featureIndex }
    5 -> { mask | mouth = featureIndex }
    _ -> mask

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Select featureIndex_ ->
      let 
        mask_ = newMask featureIndex_ model 
      in
      { model | featureIndex = featureIndex_, mask = mask_ } ! []
    SelectOver featureIndex_ -> 
      { model | featureIndexOver = featureIndex_ } ! []
    Mode typeIndex ->
      { model | featureType = typeIndex, featureIndex = 0 } ! []
    Mdl msg_ ->
      Material.update Mdl msg_ model

-- VIEW

center : Options.Property a b
center = 
  css "margin" "0 auto"

renderBorder : Html Msg
renderBorder =
  Svg.circle [
      cx "120"
    , cy "120"
    , r "100" 
    , strokeWidth "4"
    , stroke "#666"
    , fill "#f3f3f3"][]

renderFeature : Int -> Int -> Html Msg
renderFeature featureIndex featureType =
  Svg.circle [
      cx "120"
    , cy "120"
    , r (toString ((10 - featureType) * 10))
    , strokeWidth "4"
    , stroke "#666"
    , fill (getColor featureType featureIndex)][]

renderFeaturePreview : Int -> Model -> Html Msg
renderFeaturePreview featureIndex model =
  Svg.svg [width "120", height "120", viewBox "0 0 240 240"]
      [ rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#666",
          fill (if model.featureIndexOver == featureIndex then "#fff" else "#eee")] []
      , renderFeature featureIndex model.featureType
      , rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#666",
          fill "transparent",
          Svg.Events.onClick (Select featureIndex),
          Svg.Events.onMouseOver (SelectOver featureIndex)] []
      ]

view : Model -> Html Msg
view model =
  div []
    [ div [ 
        Html.Attributes.style [("text-align","center")]
      ]
      [ Svg.svg [Html.Attributes.width 240, Html.Attributes.height 240]
        [ renderBorder
        , renderFeature model.mask.face 0
        , renderFeature model.mask.hair 1      
        , renderFeature model.mask.eyes 2
        , renderFeature model.mask.eyebrows 3
        , renderFeature model.mask.nose 4
        , renderFeature model.mask.mouth 5
        ]
      ]
    , Tabs.render Mdl [5,2] model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab Mode
        , Tabs.activeTab model.featureType
        ]
        [ Tabs.label [] [ text "Face" ]
        , Tabs.label [] [ text "Hair" ]
        , Tabs.label [] [ text "Eyes" ]
        , Tabs.label [] [ text "Eyebrow" ]
        , Tabs.label [] [ text "Nose" ]
        , Tabs.label [] [ text "Mouth" ]
        ]
        (List.map (\a -> (renderFeaturePreview a model)) (List.range 0 20))
    ]
  
main : Program Never Model Msg
main =
  Html.program
    { init = init "todo"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : String -> (Model, Cmd Msg)
init _ =
  ( model , Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none    
  
-- UTILS

getColor : Int -> Int ->String
getColor t f = 
  getHSL (120+f*14) 90 80

maskAsColor : Mask -> String
maskAsColor mask = 
  "rgb(" ++ toString mask.face ++ "," ++ toString mask.hair ++ "," ++ toString mask.eyes ++ ")"

getRGB : Int -> Int -> Int -> String
getRGB r g b = 
  "rgb(" ++ toString r ++ "," ++ toString g ++ "," ++ toString b ++ ")"

getHSL : Int -> Int -> Int -> String
getHSL h s l = 
  "hsl(" ++ toString h ++ "," ++ toString s ++ "%," ++ toString l ++ "%)"  