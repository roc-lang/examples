module Main exposing (..)

import Browser
import Html exposing (Html, div, text, h1)
import Html.Attributes exposing (..)
import Http


-- MAIN

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL
type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , fetchData
  )


-- UPDATE

type Msg
    = GotResponse (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotResponse result ->
         case result of
          Ok body ->
           (Success body, Cmd.none)

          Err _ ->
             (Failure, Cmd.none)


view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text "I was unable to load your response."

    Loading ->
      text "Loading..."

    Success body ->
     div [ id "app" ]
      [
       h1 [] [ text body ]
      ]


-- HTTP REQUEST

fetchData : Cmd Msg
fetchData =
    Http.get
        { url = "http://localhost:8000/"
        , expect = Http.expectString GotResponse
        }


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
