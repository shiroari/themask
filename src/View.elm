module View exposing (view)

import Html exposing (Html, div)
import Html.Attributes as Attrs
import Svg exposing (..)
import Svg.Events
import Svg.Attributes exposing (..)
import Material.Tabs as Tabs
import Material.Dialog as Dialog
import Material.Button as Button
import Material.Options as Options
import Model exposing (..)
import Message exposing (..)
import Palette exposing (..)
import Util exposing (..)
import Gen


view : Model -> Html Msg
view model =
    div []
        [ Button.render Mdl
            [ 1 ]
            model.mdl
            [ Dialog.openOn "click", Options.onClick Save, Options.css "position" "absolute" ]
            [ text "Save" ]
        , div
            [ Attrs.style [ ( "width", "240px" ), ( "margin", "0 auto" ) ] ]
            [ maskView model
            ]
        , dialogView model
        , Tabs.render Mdl
            [ 5, 2 ]
            model.mdl
            [ Tabs.ripple
            , Tabs.onSelectTab changeFeatureType
            , Tabs.activeTab (toTabIndex model.featureType)
            ]
            (List.map (\a -> (Tabs.label [] [ text (getPalette (fromTabIndex a)).name ])) (List.range 0 7))
            (List.map (\a -> (renderFeaturePreview a model)) (List.range 0 (getPalette model.featureType).size))
        ]



---


dialogView : Model -> Html Msg
dialogView model =
    Dialog.view
        [ Options.css "width" "530px" ]
        [ Dialog.title [] [ text "Save As..." ]
        , Dialog.content []
            [ div [ Attrs.style [ ( "width", "480px" ), ( "margin", "0 auto" ) ] ]
                [ div [ Attrs.style [ ( "display", "inline-block" ) ] ]
                    [ div [ Attrs.style [ ( "text-align", "center" ) ] ] [ text "PNG" ]
                    , div [ Attrs.id "save_as_png" ] []
                    ]
                , div [ Attrs.style [ ( "display", "inline-block" ) ] ]
                    [ div [ Attrs.style [ ( "text-align", "center" ) ] ] [ text "SVG" ]
                    , div [ Attrs.id "save_as_svg" ] []
                    ]
                , div [] [ text "Click right button and select 'Save As...'" ]
                ]
            ]
        , Dialog.actions []
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                [ Dialog.closeOn "click" ]
                [ text "Close" ]
            ]
        ]


maskView : Model -> Html Msg
maskView model =
    let
        mask =
            model.mask
    in
        Svg.svg [ id "preview", width "240", height "240" ]
            [ renderBorder mask
            , renderFeature mask Face
            , renderFeature mask Eyes
            , renderFeature mask Eyebrows
            , renderFeature mask Nose
            , renderFeature mask Mouth
            , renderFeature mask Hair
            , renderActivator
            ]


renderBorder : Mask -> Html Msg
renderBorder mask =
    Svg.g []
        [ Svg.circle
            [ cx "120"
            , cy "120"
            , r "100"
            , strokeWidth "4"
            , stroke "#666"
            , fill (getColor mask.background)
            ]
            []
        ]


renderActivator : Html Msg
renderActivator =
    Svg.g []
        [ Svg.rect
            [ x "10"
            , y "10"
            , width "220"
            , height "220"
            , fill "transparent"
            , Svg.Events.onClick Save
            , Svg.Events.onMouseOut (ReadyToSave False)
            , Svg.Events.onMouseOver (ReadyToSave True)
            ]
            []
        ]


renderFeature : Mask -> Feature -> Html Msg
renderFeature mask feature =
    renderFeatureWitIndex mask feature (getFeatureIndex mask feature)


renderFeatureWitIndex : Mask -> Feature -> Int -> Html Msg
renderFeatureWitIndex mask feature featureIndex =
    let
        featureInfo =
            getPalette feature
    in
        if featureIndex == 0 && featureInfo.required /= True then
            Svg.g [] []
        else if featureIndex < featureInfo.presetSize then
            Svg.image [ xlinkHref (getFeatureFile featureIndex featureInfo) ] []
        else
            Gen.newFeature mask feature featureIndex


renderFeaturePreview : Int -> Model -> Html Msg
renderFeaturePreview featureIndex model =
    let
        feature =
            model.featureType

        featureInfo =
            getPalette feature
    in
        Svg.svg [ width "120", height "120", viewBox "0 0 240 240" ]
            [ rect
                [ x "10"
                , y "10"
                , width "220"
                , height "220"
                , rx "15"
                , ry "15"
                , strokeWidth "1"
                , stroke "#fff"
                , fill
                    (if model.featureIndexOver == featureIndex then
                        "#fff"
                     else
                        "#f1f1f1"
                    )
                ]
                []
            , if featureIndex == 0 && featureInfo.required /= True then
                Svg.image [ xlinkHref "assets/svg/na.svg" ] []
              else
                renderFeatureWitIndex model.mask feature featureIndex
            , rect
                [ x "10"
                , y "10"
                , width "220"
                , height "220"
                , rx "15"
                , ry "15"
                , strokeWidth "1"
                , stroke "#ccc"
                , fill "transparent"
                , Svg.Events.onClick (Select featureIndex)
                , Svg.Events.onMouseOut (SelectOver -1)
                , Svg.Events.onMouseOver (SelectOver featureIndex)
                ]
                []
            ]



---


changeFeatureType : Int -> Msg
changeFeatureType x =
    Mode (fromTabIndex x)


toTabIndex : Feature -> Int
toTabIndex x =
    case x of
        Face ->
            0

        Hair ->
            1

        Eyes ->
            2

        Eyebrows ->
            3

        Nose ->
            4

        Mouth ->
            5

        Background ->
            6

        _ ->
            0


fromTabIndex : Int -> Feature
fromTabIndex x =
    case x of
        0 ->
            Face

        1 ->
            Hair

        2 ->
            Eyes

        3 ->
            Eyebrows

        4 ->
            Nose

        5 ->
            Mouth

        6 ->
            Background

        _ ->
            Undefined
