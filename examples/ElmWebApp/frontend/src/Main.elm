module Main exposing (main)

import Browser
import Html exposing (Html, h1, text)
import Http



-- MAIN
-- The main function is the entry point of an Elm application.


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL
-- Model represents the state of our application.


type Model
    = Failure Http.Error
    | Loading
    | Success String



-- init sets up the initial state and any commands to run on startup.


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading
    , fetchData
    )



-- UPDATE
-- Msg represents the different types of messages our app can receive.


type Msg
    = GotResponse (Result Http.Error String)



-- update handles how the model changes in response to messages.


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GotResponse (Ok body) ->
            ( Success body, Cmd.none )

        GotResponse (Err error) ->
            ( Failure error, Cmd.none )



-- VIEW
-- view determines what to display in the browser based on the current model.


view : Model -> Html Msg
view model =
    case model of
        Failure error ->
            text ("Is the Roc webserver running? I hit an error: " ++ httpErrorToString error)

        Loading ->
            text "Loading..."

        Success body ->
            h1 [] [ text body ]


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.Timeout ->
            "The request timed out."

        Http.NetworkError ->
            "Network error."

        Http.BadStatus status ->
            "Bad status: " ++ String.fromInt status

        Http.BadBody message ->
            "Bad body: " ++ message



-- HTTP
-- fetchData sends an HTTP GET request to the Roc backend.


fetchData : Cmd Msg
fetchData =
    Http.get
        { url = "http://localhost:8000/"
        , expect = Http.expectString GotResponse
        }



-- SUBSCRIPTIONS
-- Subscriptions allow the app to listen for external input (e.g. time, websockets).
-- In this case, we're not using any subscriptions.


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
