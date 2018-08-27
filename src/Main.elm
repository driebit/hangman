module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src, value)
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
    , guesses : Set Char
    , currentGuess : String
    }


init : Model
init =
    { secret = []
    , mode = InputSecret
    , guesses = Set.empty
    , currentGuess = ""
    }


type Mode
    = InputSecret
    | PlayGame
    | GameOver



-- UPDATE


type Msg
    = Nop
    | SetCurrentGuess String
    | SetSecret String
    | StartGame
    | MakeGuess


update : Msg -> Model -> Model
update msg model =
    case msg of
        Nop ->
            model

        SetCurrentGuess value ->
            { model | currentGuess = value }

        SetSecret value ->
            { model | secret = String.toList value }

        StartGame ->
            { model | mode = PlayGame }

        MakeGuess ->
            let
                guess =
                    String.toList model.currentGuess
            in
            case guess of
                [] ->
                    model

                char :: _ ->
                    let
                        guesses =
                            Set.insert char model.guesses
                    in
                    { model
                        | guesses = guesses
                        , currentGuess = ""
                        , mode =
                            if Set.size guesses == 6 then
                                GameOver

                            else
                                PlayGame
                    }



-- VIEW


view : Model -> Html Msg
view model =
    case model.mode of
        InputSecret ->
            div []
                [ input [ onInput SetSecret, value (String.fromList model.secret) ] []
                , button [ onClick StartGame ] [ text "start" ]
                ]

        PlayGame ->
            div []
                [ div [] [ showSecret model ]
                , div []
                    [ input [ onInput SetCurrentGuess, value model.currentGuess ] []
                    , button [ onClick MakeGuess ] [ text "guess" ]
                    ]
                , showWrongGuesses model
                , showPicture model
                ]

        GameOver ->
            div []
                [ div [] [ text (String.fromList model.secret) ]
                , img [ src "../img/6.png" ] []
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
            Set.toList <|
                Set.filter
                    (\c -> not (List.member c model.secret))
                    model.guesses
    in
    div []
        [ ul [] <|
            List.map
                (\c -> li [] [ text <| String.fromChar c ])
                wrong
        ]


showPicture : Model -> Html Msg
showPicture model =
    let
        n =
            Set.size <|
                Set.filter
                    (\c -> not (List.member c model.secret))
                    model.guesses

        imgSrc =
            String.concat [ "../img/", String.fromInt n, ".png" ]
    in
    div [] [ img [ src imgSrc ] [] ]
