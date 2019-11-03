module Main exposing (..)

import Animation exposing (px, Interpolation )
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
    , style : Animation.State
    }


defaultModel : Model
defaultModel =
    { result = Routes.Loading
    , textField = "Dog"
    , style = Animation.style 
        [ Animation.paddingLeft (px 300.0)
        , Animation.paddingTop(px 0.0)
        , Animation.opacity 1.0 
        ]
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( defaultModel, Cmd.map RoutesMsg (Routes.getRandomGif defaultModel.textField) )



-- UPDATE


type Msg
    = RoutesMsg Routes.Msg
    | Animate Animation.Msg
    | FadeInAndOut


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RoutesMsg msg_ ->
            updateWith RoutesMsg model <|
                Routes.update msg_ <|
                    model

        Animate msg_ ->
            ( { model | style = Animation.update msg_ model.style }, Cmd.none )

        FadeInAndOut ->
            ( { model
                | style =
                    Animation.interrupt
                        [ Animation.toWith (Animation.spring {stiffness=100, damping=10 })
                            [ Animation.paddingLeft (px 50.0)
                            ]
                        , Animation.toWith (Animation.spring {stiffness=100, damping=10 })
                            [ Animation.paddingLeft (px 300.0)
                            ]
                        ]
                        model.style
              }
            , Cmd.none
            )


updateWith : (subMsg -> Msg) -> Model -> ( Model, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toMsg model ( subModel, subCmd ) =
    ( subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]



-- VIEW


view : Model -> Html Msg
view model =
    div (Animation.render model.style ++ [onClick FadeInAndOut])
        [ h2 [] [ text ("Random " ++ namer model.textField) ]
        , Html.map RoutesMsg (Routes.viewGif model)
        ]


namer : String -> String
namer input =
    if input == "" then
        "Gifs"

    else
        input ++ "s"
