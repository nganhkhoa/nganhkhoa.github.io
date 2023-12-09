module Route.Blog exposing (ActionData, Data, Model, Msg, route)

import Article
import BackendTask exposing (BackendTask)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
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
        [ Link.link (Link.internal (Route.Index)) []
            [ text "Home" ]
        , div [] (app.data |> List.map renderBlogItem)
        ]
    }

renderBlogItem : (Route, Article.ArticleMetadata) -> Html msg
renderBlogItem (route_, article) =
    Link.link (Link.internal route_) []
        [ div []
            [ div []
                [ text article.title
                ]
            ]
        ]
