module Routes exposing (..)
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (Decoder, field, string)

-- MODEL
type Outcome
  = Failure
  | Loading
  | Success String



-- UPDATE
type Msg
  = MorePlease
  | GotGif (Result Http.Error String)
  | UpdateText String


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



-- VIEW

namer : String -> String
namer input = 
  if input == "" then
    "Gifs"

  else
    input ++ "s"

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