module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)
import Routes



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { result : Routes.Outcome
    , textField : String
    }


defaultModel : Model
defaultModel =
    { result = Routes.Loading
    , textField = "Dog"
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.map RoutesMsg (Routes.getRandomGif defaultModel.textField) )



-- UPDATE


type Msg
    = RoutesMsg Routes.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RoutesMsg msg_ ->
            updateWith RoutesMsg model
              <| Routes.update msg_
              <| model
              


updateWith : (subMsg -> Msg) -> Model -> ( Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( subModel
    , Cmd.map toMsg subCmd
    )
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text ("Random " ++ namer model.textField) ]
        , Html.map RoutesMsg (Routes.viewGif model)
        ]


namer : String -> String
namer input =
    if input == "" then
        "Gifs"

    else
        input ++ "s"
