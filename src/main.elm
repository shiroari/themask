import Html exposing (Html, div)
import Html.Events exposing (onClick)
import Bitwise exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Svg exposing (..)
import Svg.Attributes
import Html.Attributes 

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

type alias Model = {
  featureType: Int,
  featureIndex: Int,
  mask: Int,
  mdl : Material.Model
}

model : Model
model = { featureType=0, featureIndex=0, mask=0, mdl=Material.model }

-- UPDATE

type Msg
  = Mdl (Material.Msg Msg)
  | Next 
  | Prev 
  | Mode (Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Next ->
      { model | featureIndex = model.featureIndex + 10,
        mask = or (and model.mask (complement (shiftLeftBy (model.featureType*8) 255))) (shiftLeftBy (model.featureType*8) (model.featureIndex + 1)) 
        } ! [] 
    Prev ->
      { model | featureIndex = model.featureIndex - 10,
        mask = or (and model.mask (complement (shiftLeftBy (model.featureType*8) 255))) (shiftLeftBy (model.featureType*8) (model.featureIndex - 1)) 
        } ! [] 
    Mode typeIndex ->
      { model | featureType = typeIndex, 
        featureIndex = and 255 (shiftRightBy (typeIndex*8) model.mask)
        } ! [] 
    Mdl msg_ ->
      Material.update Mdl msg_ model

-- VIEW

center : Options.Property a b
center = 
  css "margin" "0 auto"

view : Model -> Html Msg
view model =
  div []
    [ div [ 
        Html.Attributes.style [("text-align","center")]
      ]
      [ Svg.svg [Html.Attributes.width 200, Html.Attributes.height 200]
        [
          Svg.circle [
            Svg.Attributes.cx "100"
          , Svg.Attributes.cy "100"
          , Svg.Attributes.r "80" 
          , Svg.Attributes.strokeWidth "4"
          , Svg.Attributes.stroke "#666"
          , Svg.Attributes.fill (maskAsColor model.mask)][]
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
        [ div [][Button.render Mdl [2, 0, 0, 1] model.mdl
                [ Button.ripple
                , Button.colored
                , Button.raised
                , Options.onClick Prev
                ]
                [ text "Previous" ]
              , Button.render Mdl [3, 0, 0, 1] model.mdl
                [ Button.ripple
                , Button.colored
                , Button.raised
                , Options.onClick Next
                ]
                [ text "Next" ]
            ]
        ]
    ]
  
--main : Program Never Model Msg
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

maskAsColor : Int -> String
maskAsColor num = 
  let cl = List.intersperse "," (maskAsColor_ 3 num [])
    in
  "rgb(" ++ ( List.foldl (++) "" cl ) ++ ")"

maskAsColor_ : Int -> Int -> List String -> List String
maskAsColor_ idx num res = 
  case idx of 
    0 -> res
    _ -> maskAsColor_ (idx - 1) (shiftRightBy 8 num) ((toString (and 255 num) :: res))


maskAsString : Int -> String
maskAsString num = showMask_ 4 num ""

showMask_ : Int -> Int -> String -> String
showMask_ idx num res = 
  case idx of 
    0 -> res
    _ -> showMask_ (idx - 1) (shiftRightBy 8 num) (res ++ toString (and 255 num))