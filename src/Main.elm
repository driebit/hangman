module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { secret : List Char
    , mode : Mode
    }


type Mode
    = InputSecret
    | PlayGame


init : Model
init =
    { secret = []
    , mode = InputSecret
    }



-- UPDATE


type Msg
    = Nop
    | SetSecret String
    | StartGame


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        SetSecret value ->
            { model | secret = String.toList value }

        StartGame ->
            { model | mode = PlayGame }



-- VIEW


view : Model -> Html Msg
view model =
    case model.mode of
        InputSecret ->
            div []
                [ input [ onInput SetSecret ] []
                , button [ onClick StartGame ] [ text "start" ]
                ]

        PlayGame ->
            div [] [ showSecret model ]


showSecret : Model -> Html Msg
showSecret model =
    let
        n =
            List.length model.secret
    in
    text <| String.fromList <| List.repeat n '*'
