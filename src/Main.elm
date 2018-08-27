module Main exposing (main)

import Browser
import Html exposing (Html, div, text)


main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { secret : String }


init : Model
init =
    { secret = "" }



-- UPDATE


type Msg
    = Nop


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [] [ text model.secret ]
