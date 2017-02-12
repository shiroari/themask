import Platform.Cmd exposing (Cmd, none)

import Html exposing (Html, div)
import Html.Attributes 

import Svg exposing (..)
import Svg.Events
import Svg.Attributes exposing (..)

import Material
import Material.Tabs as Tabs

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

type alias Mask = {
  sex: Int,
  face: Int,
  hair: Int,
  eyes: Int,
  eyebrows: Int,
  nose: Int,
  mouth: Int,
  background: Int
}

type alias Palette = {
  name: String,
  required: Bool,
  path: String,
  presetSize: Int,
  size: Int
}

toFeature: Int -> Feature
toFeature x = 
  case x of
  0 -> Face
  1 -> Hair
  2 -> Eyes
  3 -> Eyebrows
  4 -> Nose
  5 -> Mouth
  6 -> Background
  _ -> Undefined

getPalette: Feature -> Palette
getPalette x = 
  case x of
  Sex -> { name = "Sex", required = True, path = "", presetSize = 0, size = 0 }
  Face -> { name = "Face", required = True, path = "/face", presetSize = 1, size = 25 }
  Hair -> { name = "Hair", required = False, path = "/hair", presetSize = 0, size = 20 }
  Eyes -> { name = "Eyes", required = False, path = "/eyes", presetSize = 0, size = 12 }
  Eyebrows -> { name = "Eyebrow", required = False, path = "/eyebrows", presetSize = 0, size = 20 }
  Nose -> { name = "Nose", required = False, path = "/nose", presetSize = 0, size = 20 }
  Mouth -> { name = "Mouth", required = False, path = "/mouth", presetSize = 0, size = 14 }
  Background -> { name = "Background", required = True, path = "", presetSize = 0, size = 23 }
  Undefined -> { name = "", required = False, path = "", presetSize = 0, size = 0 }

-- MODEL

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
    featureIndexOver = -1,
    mask = { 
      background = 0,
      sex = 0, 
      face = 0, 
      hair = 0, 
      eyes = 4, 
      eyebrows = 1,
      nose = 0,
      mouth = 1
      },
    mdl = Material.model 
  }

getFeature: Mask -> Feature -> Int
getFeature mask feature =
  case feature of
    Face -> mask.face
    Hair -> mask.hair
    Eyes -> mask.eyes
    Eyebrows -> mask.eyebrows
    Nose -> mask.nose
    Mouth -> mask.mouth
    Sex -> mask.sex
    Background -> mask.background
    Undefined -> 0

-- UPDATE

type Msg
  = Mdl (Material.Msg Msg)
  | Select (Int)
  | SelectOver (Int)
  | Mode (Int)

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

newMask: Int -> Model -> Mask
newMask featureIndex model =
  let 
    mask = model.mask
    feature = toFeature model.featureType
  in
  case feature of
    Face -> { mask | face = featureIndex }
    Hair -> { mask | hair = featureIndex }
    Eyes -> { mask | eyes = featureIndex }
    Eyebrows -> { mask | eyebrows = featureIndex }
    Nose -> { mask | nose = featureIndex }
    Mouth -> { mask | mouth = featureIndex }
    Background -> { mask | background = featureIndex }
    Sex -> { mask | sex = featureIndex }
    Undefined -> { mask | mouth = featureIndex }

-- VIEW

maskView : Mask -> Html Msg
maskView mask =
  Svg.svg [id "avatar", width "240", height "240"]
    [ renderBorder mask
    , renderFeature mask Face
    , renderFeature mask Eyes
    , renderFeature mask Eyebrows
    , renderFeature mask Nose
    , renderFeature mask Mouth
    , renderFeature mask Hair
    ]

view : Model -> Html Msg
view model =
  let
    feature = toFeature model.featureType
  in
  div []
    [ div [ Html.Attributes.style [("text-align","center")] ][ maskView model.mask ]
    , Tabs.render Mdl [5,2] model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab Mode
        , Tabs.activeTab model.featureType
        ]
        (List.map (\a -> (Tabs.label [] [ text (getPalette (toFeature a)).name ])) (List.range 0 7))
        (List.map (\a -> (renderFeaturePreview a model)) (List.range 0 (getPalette feature).size))
    ]
  
main : Program Never Model Msg
main =
  Html.program
    { init = init ""
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
  
-- 

renderBorder : Mask -> Html Msg
renderBorder mask = Svg.g []
  [ Svg.circle [
        cx "120"
      , cy "120"
      , r "100"
      , strokeWidth "4"
      , stroke "#666"
      , fill (getColor mask.background)][]
  ]

renderFeature : Mask -> Feature -> Html Msg
renderFeature mask feature =
  renderFeatureWitIndex mask feature (getFeature mask feature)

renderFeatureWitIndex : Mask -> Feature -> Int -> Html Msg
renderFeatureWitIndex mask feature featureIndex =
  let 
    featureInfo = getPalette feature
  in
  if featureIndex == 0 && featureInfo.required /= True 
    then Svg.g[][] 
  else if featureIndex < featureInfo.presetSize 
    then Svg.image [xlinkHref (getFeatureFile featureIndex featureInfo)][]
  else
  renderGenFeature mask feature featureIndex

renderFeaturePreview : Int -> Model -> Html Msg
renderFeaturePreview featureIndex model =
  let 
    feature = toFeature model.featureType
    featureInfo = getPalette feature
  in
  Svg.svg [width "120", height "120", viewBox "0 0 240 240"]
      [ rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#fff",
          fill (if model.featureIndexOver == featureIndex then "#fff" else "#f1f1f1")] []
      , 
      if featureIndex == 0 && featureInfo.required /= True
        then Svg.image [xlinkHref "assets/svg/na.svg"][] 
        else renderFeatureWitIndex model.mask feature featureIndex
      , rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#ccc",
          fill "transparent",
          Svg.Events.onClick (Select featureIndex),
          Svg.Events.onMouseOut (SelectOver -1),
          Svg.Events.onMouseOver (SelectOver featureIndex)] []
      ]

renderGenFeature : Mask -> Feature -> Int -> Html Msg
renderGenFeature mask feature featureIndex = 
  case feature of
    Background -> 
        rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "transparent",
          fill (getColor featureIndex)] []           
    Face -> Svg.g []
        [ Svg.path [ 
            strokeWidth "4",
            stroke "#666",
            fill getSkinTone,
            d ("M70 140 C " ++ toString (110 - featureIndex*3) ++ " 200, " ++ toString (130 + featureIndex*3) ++ " 200" ++ ", 170 140") ][]
        , Svg.path [ 
            strokeWidth "4",
            stroke "#666",
            fill getSkinTone,
            d ("M70 140 C " ++ toString (70 - featureIndex*3) ++ " 30, " ++ toString (170 + featureIndex*3) ++ " 30" ++ ", 170 140") ][]
        ]
    Hair -> 
      Svg.g []
      (List.map (\a -> 
        let     
          af = (toFloat a)  
          alpha = af/Basics.pi
          s = 50.0
          e = 55.0 + toFloat(featureIndex) + (10*sin(alpha))
        in (Svg.line [
          x1 (toString (120 + s*(cos alpha))),
          y1 (toString (120 - s*(sin alpha))),
          x2 (toString (120 + e*(cos alpha))),
          y2 (toString (120 - e*(sin alpha))),
          strokeWidth "4", stroke "#666"][]
        )) (List.range 0 10))
    Eyes -> Svg.g []
      [ Svg.ellipse [
            cx "90"
          , cy "120"
          , rx (toString (3 + featureIndex))
          , ry (toString (14 - featureIndex))
          , strokeWidth "2"
          , stroke "#666"
          , fill "#666"][]
      , Svg.ellipse [
            cx "150"
          , cy "120"
          , rx (toString (3 + featureIndex))
          , ry (toString (14 - featureIndex))
          , strokeWidth "2"
          , stroke "#666"
          , fill "#666"][]     
      ]
    Eyebrows -> Svg.g []
      [ Svg.path [ 
            strokeWidth "4",
            stroke "#666",
            fill "none",
            d ("M80 100 C " ++ toString (90 - featureIndex) ++ " 90, " ++ toString (90 + featureIndex) ++ " 90" ++ ", 100 100") ][]
      , Svg.path [ 
            strokeWidth "4",
            stroke "#666",
            fill "none",
            d ("M140 100 C " ++ toString (150 - featureIndex) ++ " 90, " ++ toString (150 + featureIndex) ++ " 90" ++ ", 160 100") ][]   
      ]
    Nose -> Svg.path [ 
            strokeWidth "4",
            stroke "#666",
            fill "none",
            d ("M110 140 C " ++ toString (120 - featureIndex) ++ " 150, " ++ toString (120 + featureIndex) ++ " 150" ++ ", 130 140") ][]
    Mouth -> Svg.ellipse [
            cx "120"
          , cy "165"
          , rx (toString (20 - featureIndex))
          , ry (toString (1 + featureIndex))
          , strokeWidth "2"
          , stroke "#666"
          , fill "#666"][] 
    _ -> Svg.g [][]    

getColor : Int ->String
getColor c = 
  if c == 0 then "#eee" else
  getHSL (100+c*14) 90 80

getRGB : Int -> Int -> Int -> String
getRGB r g b = 
  "rgb(" ++ toString r ++ "," ++ toString g ++ "," ++ toString b ++ ")"

getHSL : Int -> Int -> Int -> String
getHSL h s l = 
  "hsla(" ++ toString h ++ "," ++ toString s ++ "%," ++ toString l ++ "%,1.0)"      

getSkinTone: String
getSkinTone = 
  getHSL 41 100 87

getFeatureFile: Int -> Palette -> String
getFeatureFile featureIndex featureInfo =
   "assets/svg" ++ featureInfo.path ++ "/"  ++ (String.padLeft 3 '0' (toString (featureIndex+1))) ++ ".svg"