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
  | Undefined

type alias Mask = {
  sex: Int,
  face: Int,
  hair: Int,
  eyes: Int,
  eyebrows: Int,
  nose: Int,
  mouth: Int  
}

type alias Palette = {
  name: String,
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
  _ -> Undefined

palette: Feature -> Palette
palette x = 
  case x of
  Sex -> { name = "Sex", size = 2 }
  Face -> { name = "Face", size = 20 }
  Hair -> { name = "Hair", size = 18 }
  Eyes -> { name = "Eyes", size = 12 }
  Eyebrows -> { name = "Eyebrow", size = 20 }
  Nose -> { name = "Nose", size = 20 }
  Mouth -> { name = "Mouth", size = 12 }
  Undefined -> { name = "", size = 0 }

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
      sex = 0, 
      face = 19, 
      hair = 9, 
      eyes = 4, 
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
    feature = toFeature model.featureType
  in
  case feature of
    Face -> { mask | face = featureIndex }
    Hair -> { mask | hair = featureIndex }
    Eyes -> { mask | eyes = featureIndex }
    Eyebrows -> { mask | eyebrows = featureIndex }
    Nose -> { mask | nose = featureIndex }
    Mouth -> { mask | mouth = featureIndex }
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

renderBorder : Html Msg
renderBorder =
  Svg.circle [
      cx "120"
    , cy "120"
    , r "100" 
    , strokeWidth "4"
    , stroke "#666"
    , fill "#f3f3f3"][] 

renderFeature : Int -> Feature -> Html Msg
renderFeature featureIndex feature =
  if (featureIndex == 0) && (feature /= Face) 
  then Svg.g[][] 
  else
  case feature of
  Face -> Svg.g []
      [ Svg.path [ 
          strokeWidth "4",
          stroke "#666",
          fill "rgb(255, 234, 189)",
          d ("M70 140 C " ++ toString (110 - featureIndex*3) ++ " 200, " ++ toString (130 + featureIndex*3) ++ " 200" ++ ", 170 140") ][]
      , Svg.path [ 
          strokeWidth "4",
          stroke "#666",
          fill "rgb(255, 234, 189)",
          d ("M70 140 C " ++ toString (70 - featureIndex*3) ++ " 30, " ++ toString (170 + featureIndex*3) ++ " 30" ++ ", 170 140") ][]
      ]
  Hair -> 
    Svg.g []
    (List.map (\a -> 
      let     
        af = (toFloat a)  
        alpha = af/3.14
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

renderFeaturePreview : Int -> Model -> Html Msg
renderFeaturePreview featureIndex model =
  Svg.svg [width "120", height "120", viewBox "0 0 240 240"]
      [ rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#fff",
          fill (if model.featureIndexOver == featureIndex then "#fff" else "#f1f1f1")] []
      , 
      if (featureIndex == 0) && (model.featureType >= 1) 
        then Svg.image [xlinkHref "./na.svg"][] 
        else renderFeature featureIndex (toFeature model.featureType)
      , rect [ 
          x "10", y "10", width "220", height "220", rx "15", ry "15",
          strokeWidth "1",
          stroke "#ccc",
          fill "transparent",
          Svg.Events.onClick (Select featureIndex),
          Svg.Events.onMouseOut (SelectOver -1),
          Svg.Events.onMouseOver (SelectOver featureIndex)] []
      ]

maskView : Model -> Html Msg
maskView model = 
  Svg.svg [Html.Attributes.width 240, Html.Attributes.height 240]
    [ renderBorder
    , renderFeature model.mask.hair Hair  
    , renderFeature model.mask.face Face
    , renderFeature model.mask.eyes Eyes
    , renderFeature model.mask.eyebrows Eyebrows
    , renderFeature model.mask.nose Nose
    , renderFeature model.mask.mouth Mouth
    ]

view : Model -> Html Msg
view model =
  let
    feature = toFeature model.featureType
  in
  div []
    [ div [ Html.Attributes.style [("text-align","center")] ][ maskView model ]
    , Tabs.render Mdl [5,2] model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab Mode
        , Tabs.activeTab model.featureType
        ]
        (List.map (\a -> (Tabs.label [] [ text (palette (toFeature a)).name ])) (List.range 0 6))
        (List.map (\a -> (renderFeaturePreview a model)) (List.range 0 (palette feature).size))
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
  "hsla(" ++ toString h ++ "," ++ toString s ++ "%," ++ toString l ++ "%,1.0)"  