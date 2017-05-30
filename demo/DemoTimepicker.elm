module Demo exposing (main)

import Css
import Date exposing (Date)
import Date.Extra.Config.Config_en_us exposing (config)
import Date.Extra.Format
import DateParser
import DateTimePicker
import DateTimePicker.Config exposing (Config, DatePickerConfig, TimePickerConfig, defaultDatePickerConfig, defaultDateTimeI18n, defaultDateTimePickerConfig, defaultTimePickerConfig)
import DateTimePicker.Css
import DemoCss exposing (CssClasses(..))
import Html exposing (Html, div, form, label, li, p, text, ul)
import Html.CssHelpers


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { timeValue : Maybe Date
    , timePickerState : DateTimePicker.State
    }


init : ( Model, Cmd Msg )
init =
    ( { timeValue = Just (Date.fromTime 1500000000)
      , timePickerState = DateTimePicker.initialState
      }
    , Cmd.batch
        [ DateTimePicker.initialCmd (\a _ -> TimeChanged a (Just (Date.fromTime 1500000000000))) DateTimePicker.initialState
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


{ id, class, classList } =
    Html.CssHelpers.withNamespace ""


timePickerConfig : Config TimePickerConfig Msg
timePickerConfig =
    let
        defaultDateTimeConfig =
            defaultTimePickerConfig TimeChanged
    in
    { defaultDateTimeConfig
        | timePickerType = DateTimePicker.Config.Analog
    }


view : Model -> Html Msg
view model =
    let
        { css } =
            Css.compile [ DateTimePicker.Css.css, DemoCss.css ]
    in
    form []
        [ Html.node "style" [] [ Html.text css ]
        , div [ class [ Container ] ]
            [ p
                []
                [ label []
                    [ text "Time Picker: "
                    , DateTimePicker.timePicker
                        TimeChanged
                        []
                        model.timePickerState
                        model.timeValue
                    ]
                ]
            , p []
                [ ul []
                    [ li []
                        [ text "Time: ", text <| toString model.timeValue ]
                    ]
                ]
            ]
        ]


type Msg
    = NoOp
    | TimeChanged DateTimePicker.State (Maybe Date)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        TimeChanged state value ->
            ( { model | timeValue = value, timePickerState = state }, Cmd.none )
