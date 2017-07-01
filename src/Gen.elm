module Gen exposing (newFeature)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Model exposing (..)
import Message exposing (Msg)
import Util exposing (..)


newFeature : Mask -> Feature -> Int -> Html Msg
newFeature mask feature featureIndex =
    case feature of
        Background ->
            rect
                [ x "10"
                , y "10"
                , width "220"
                , height "220"
                , rx "15"
                , ry "15"
                , strokeWidth "1"
                , stroke "transparent"
                , fill (getColor featureIndex)
                ]
                []

        Face ->
            Svg.g []
                [ Svg.path
                    [ strokeWidth "4"
                    , stroke "#666"
                    , fill getSkinTone
                    , d ("M70 140 C " ++ toString (110 - featureIndex * 3) ++ " 200, " ++ toString (130 + featureIndex * 3) ++ " 200" ++ ", 170 140")
                    ]
                    []
                , Svg.path
                    [ strokeWidth "4"
                    , stroke "#666"
                    , fill getSkinTone
                    , d ("M70 140 C " ++ toString (70 - featureIndex * 3) ++ " 30, " ++ toString (170 + featureIndex * 3) ++ " 30" ++ ", 170 140")
                    ]
                    []
                ]

        Hair ->
            Svg.g []
                (List.map
                    (\a ->
                        let
                            af =
                                (toFloat a)

                            alpha =
                                af / Basics.pi

                            s =
                                50.0

                            e =
                                55.0 + toFloat (featureIndex) + (10 * sin (alpha))
                        in
                            (Svg.line
                                [ x1 (toString (120 + s * (cos alpha)))
                                , y1 (toString (120 - s * (sin alpha)))
                                , x2 (toString (120 + e * (cos alpha)))
                                , y2 (toString (120 - e * (sin alpha)))
                                , strokeWidth "4"
                                , stroke "#666"
                                ]
                                []
                            )
                    )
                    (List.range 0 10)
                )

        Eyes ->
            Svg.g []
                [ Svg.ellipse
                    [ cx "90"
                    , cy "120"
                    , rx (toString (3 + featureIndex))
                    , ry (toString (14 - featureIndex))
                    , strokeWidth "2"
                    , stroke "#666"
                    , fill "#666"
                    ]
                    []
                , Svg.ellipse
                    [ cx "150"
                    , cy "120"
                    , rx (toString (3 + featureIndex))
                    , ry (toString (14 - featureIndex))
                    , strokeWidth "2"
                    , stroke "#666"
                    , fill "#666"
                    ]
                    []
                ]

        Eyebrows ->
            Svg.g []
                [ Svg.path
                    [ strokeWidth "4"
                    , stroke "#666"
                    , fill "none"
                    , d ("M80 100 C " ++ toString (90 - featureIndex) ++ " 90, " ++ toString (90 + featureIndex) ++ " 90" ++ ", 100 100")
                    ]
                    []
                , Svg.path
                    [ strokeWidth "4"
                    , stroke "#666"
                    , fill "none"
                    , d ("M140 100 C " ++ toString (150 - featureIndex) ++ " 90, " ++ toString (150 + featureIndex) ++ " 90" ++ ", 160 100")
                    ]
                    []
                ]

        Nose ->
            Svg.path
                [ strokeWidth "4"
                , stroke "#666"
                , fill "none"
                , d ("M110 140 C " ++ toString (120 - featureIndex) ++ " 150, " ++ toString (120 + featureIndex) ++ " 150" ++ ", 130 140")
                ]
                []

        Mouth ->
            Svg.ellipse
                [ cx "120"
                , cy "165"
                , rx (toString (20 - featureIndex))
                , ry (toString (1 + featureIndex))
                , strokeWidth "2"
                , stroke "#666"
                , fill "#666"
                ]
                []

        _ ->
            Svg.g [] []
