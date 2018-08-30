module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (value)
import Html.Events exposing (onClick, onInput)
import Set exposing (Set)


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
    , currentGuess : String
    , guesses : Set Char
    }


type Mode
    = InputSecret
    | PlayGame


init : Model
init =
    { secret = []
    , mode = InputSecret
    , currentGuess = ""
    , guesses = Set.empty
    }



-- UPDATE


type Msg
    = Nop
    | SetSecret String
    | SetCurrentGuess String
    | MakeGuess
    | StartGame


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        SetSecret value ->
            { model | secret = String.toList value }

        SetCurrentGuess value ->
            { model | currentGuess = value }

        MakeGuess ->
            let
                guess =
                    String.toList model.currentGuess
            in
            case List.head guess of
                Nothing ->
                    model

                Just char ->
                    { model
                        | guesses = Set.insert char model.guesses
                        , currentGuess = ""
                    }

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
            div []
                [ div [] [ showSecret model ]
                , div []
                    [ input [ onInput SetCurrentGuess, value model.currentGuess ] []
                    , button [ onClick MakeGuess ] [ text "guess" ]
                    ]
                , div [] [ showWrongGuesses model ]
                ]


showSecret : Model -> Html Msg
showSecret model =
    let
        showChar c =
            if Set.member c model.guesses then
                c

            else
                '*'
    in
    text <| String.fromList <| List.map showChar model.secret


showWrongGuesses : Model -> Html Msg
showWrongGuesses model =
    let
        wrong =
            Set.filter (\c -> not (List.member c model.secret))
                model.guesses
    in
    div []
        [ ul [] <|
            List.map (\c -> li [] [ text (String.fromChar c) ]) <|
                Set.toList wrong
        ]
