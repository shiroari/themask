module Util exposing (getColor, getRGB, getHSL, getSkinTone)


getColor : Int -> String
getColor c =
    if c == 0 then
        "#eee"
    else
        getHSL (100 + c * 14) 90 80


getRGB : Int -> Int -> Int -> String
getRGB r g b =
    "rgb(" ++ toString r ++ "," ++ toString g ++ "," ++ toString b ++ ")"


getHSL : Int -> Int -> Int -> String
getHSL h s l =
    "hsla(" ++ toString h ++ "," ++ toString s ++ "%," ++ toString l ++ "%,1.0)"


getSkinTone : String
getSkinTone =
    getHSL 41 100 87
