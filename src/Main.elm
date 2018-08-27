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
    { secret : String
    , mode : Mode
    }


type Mode
    = InputSecret
    | PlayGame


init : Model
init =
    { secret = ""
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
            { model | secret = value }

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
            div [] [ text model.secret ]
