module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)



-- MAIN
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- MODEL
type Outcome
  = Failure
  | Loading
  | Success String

type alias Model =
   { result: Outcome
   , textField: String
   }


defaultModel: Model
defaultModel =
   { result = Loading
   , textField = "Dog"
   }
init : () -> (Model, Cmd Msg)
init _ =
  (defaultModel, getRandomGif defaultModel.textField)



-- UPDATE
type Msg
  = MorePlease
  | GotGif (Result Http.Error String)
  | UpdateText String


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      ({ model | result = Loading }, (getRandomGif model.textField))

    GotGif result ->
      case result of
        Ok url ->
          ({ model | result = (Success url) }, Cmd.none)

        Err _ ->
          ({ model | result = Failure }, Cmd.none)
    UpdateText newString ->
      ({ model | textField = newString}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ h2 [] [ text ("Random " ++ (namer model.textField))]
    , viewGif model
    ]

namer : String -> String
namer input = 
  if input == "" then
    "Gifs"

  else
    input ++ "s"

    
viewGif : Model -> Html Msg
viewGif model =
  case model.result of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        , button [ onClick MorePlease ] [ text "Try Again!" ]
        ]

    Loading ->
      text "Loading..."

    Success url ->
      div []
        [ input [value model.textField, onInput UpdateText] []
        , button [ onClick MorePlease, style "display" "block" ] [ text "More Please!" ]
        , img [ src url ] []
        ]



-- HTTP
getRandomGif : String -> Cmd Msg
getRandomGif arg =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ arg
    , expect = Http.expectJson GotGif gifDecoder
    }


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)