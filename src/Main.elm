module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onInput)


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


init : Model
init =
    { secret = ""
    , mode = InputSecret
    }



-- UPDATE


type Msg
    = Nop
    | SetSecret String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        SetSecret value ->
            { model | secret = value }



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ input [ onInput SetSecret ] [] ]
