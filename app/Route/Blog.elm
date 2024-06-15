module Route.Blog exposing (ActionData, Data, Model, Msg, route)

import Article
import BackendTask exposing (BackendTask)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (style, class)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)
import Link


import Markdown.Block
import Markdown.Renderer
import MarkdownCodec
import TailwindMarkdownRenderer
import Tailwind.Utilities as Tw


type alias Model =
    {}


type alias Msg =
    ()

type alias RouteParams =
    {}

route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


type alias Data =
    List (Route, Article.ArticleMetadata)

type alias ActionData =
    {}


data : BackendTask FatalError Data
data =
    Article.blogAllMetadata
    |> BackendTask.allowFatal

head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "nganhkhoa blogs"
        , image =
            { url = Pages.Url.external ""
            , alt = "nganhkhoa blogs"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "blogs"
        , locale = Nothing
        , title = "nganhkhoa blogs"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View msg
view app shared =
    { title = "nganhkhoa blogs"
    , body =
        [ section
            [ style "margin-top" "10px" ]
            [ p []
                [ text "A share of my writings, many of them I wrote when I was still in university and not technically good. I also wrote a"
                , text " "
                , Link.link (Link.internal (Route.Osx__Slug_ { slug = "" })) [] [ text "series" ]
                , text " "
                , text "about the Mach-O binary format, used in Apple devices." ]
            , div [] (app.data |> List.map renderBlogItem)
            ]
        ]
    }

renderBlogItem : (Route, Article.ArticleMetadata) -> Html msg
renderBlogItem (route_, article) =
    div []
    [ Link.link (Link.internal route_) [ style "text-decoration" "none" ]
        [ ul
            []
            [ li []
                [ h3 [] [ text article.title ]
                , p [] [ text article.subtitle ]
                ]
            ]
        ]
    -- , span [ class "marginnote", style "margin-right" "0" ] [ text (Date.toIsoString article.published) ]
    ]
