module Route.Osx exposing (ActionData, Data, Model, Msg, route)

import Article
import BackendTask exposing (BackendTask)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attributes
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
    Article.osxAllMetadata
    |> BackendTask.allowFatal

head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View msg
view app shared =
    { title = "title"
    , body =
        [ div []
            [ text "For years, I learned how the Apple binary format works."
            , text "There are blog posts that I wrote when I first started learning about them."
            , text "If you want to read them, here they are below, ported from the efiens blog."
            , ul []
                (List.map (\item -> li [] [item]) oldBlogs)
            , br [] []
            , text "I gree my idea in injection into an obfuscation scheme for MachO binary."
            , text "In the following whitepaper, I writeup all steps in this obfuscation scheme."
            , Link.link (Link.external whitepaper)
                [Attributes.target "_blank"]
                [text "macho-obfuscation.pdf"]
            ]
        ]
    }

oldBlogs : List (Html msg)
oldBlogs =
    [ (Link.link (Link.internal (Route.Osx__Slug_ { slug = "macho" })) [] [text "Macho"] )
    , (Link.link (Link.internal (Route.Osx__Slug_ { slug = "linker" })) [] [text "Linker"] )
    , (Link.link (Link.internal (Route.Osx__Slug_ { slug = "fairplay" })) [] [text "Fairplay"] )
    , (Link.link (Link.internal (Route.Osx__Slug_ { slug = "inject" })) [] [text "Inject"] )
    ]

whitepaper : String
whitepaper = "/macho-obfuscation.pdf"

