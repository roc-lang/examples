module Main exposing (..)

-- Importing necessary modules
import Browser
import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (..)
import Http

-- MAIN

-- The main function is the entry point of an Elm application
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- MODEL

-- Model represents the state of our application
type Model
  = Failure String
  | Loading
  | Success String

-- init function sets up the initial state and any commands to run on startup
init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , fetchData
  )

-- UPDATE

-- Msg represents the different types of messages our app can receive
type Msg
    = GotResponse (Result Http.Error String)

-- update function handles how the model changes in response to messages
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotResponse result ->
         case result of
          Ok body ->
           (Success body, Cmd.none)
          Err error ->
             (Failure (Debug.toString error), Cmd.none)

-- VIEW

-- view function determines what to display in the browser based on the current model
view : Model -> Html Msg
view model =
  case model of
    Failure errorMsg ->
      text ("Is the Roc webserver running? I hit an error: " ++ errorMsg)
    Loading ->
      text "Loading..."
    Success body ->
     div [ id "app" ]
      [
       h1 [] [ text body ]
      ]

-- HTTP

-- fetchData sends an HTTP GET request to the Roc backend
fetchData : Cmd Msg
fetchData =
    Http.get
        { url = "http://localhost:8000/"
        , expect = Http.expectString GotResponse
        }

-- SUBSCRIPTIONS

-- subscriptions allow the app to listen for external input (e.g., time, websockets)
-- In this case, we're not using any subscriptions
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none