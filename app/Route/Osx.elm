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
import Link
import Markdown.Block
import Markdown.Renderer
import MarkdownCodec
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route exposing (Route)
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import Tailwind.Utilities as Tw
import TailwindMarkdownRenderer
import View exposing (View)


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
    List ( Route, Article.ArticleMetadata )


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
        , siteName = "nganhkhoa osx series"
        , image =
            { url = Pages.Url.external ""
            , alt = "nganhkhoa osx series"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "An OSX series"
        , locale = Nothing
        , title = "OSX"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View msg
view app shared =
    { title = "nganhkhoa osx series"
    , body =
        [ section []
            [ p []
                [ text "For years, I learned how the Apple binary format works. There are blog posts that I wrote when I first started learning about them. If you want to read them, here they are below, ported from the efiens blog."
                , ul []
                    (List.map (\item -> li [] [ item ]) oldBlogs)
                , br [] []
                , text "Through understanding the loading process of Mach-O, I devised a technique for obfuscation and hooking. In the following whitepaper, I writeup all steps in this obfuscation scheme."
                , br [] []
                , Link.link (Link.external whitepaper)
                    [ Attributes.target "_blank" ]
                    [ text "whitepaper" ]
                ]
            ]
        ]
    }


oldBlogs : List (Html msg)
oldBlogs =
    [ Link.link (Link.internal (Route.Osx__Slug_ { slug = "macho" })) [] [ text "Macho" ]
    , Link.link (Link.internal (Route.Osx__Slug_ { slug = "linker" })) [] [ text "Linker" ]
    , Link.link (Link.internal (Route.Osx__Slug_ { slug = "fairplay" })) [] [ text "Fairplay" ]
    , Link.link (Link.internal (Route.Osx__Slug_ { slug = "injection" })) [] [ text "Injection" ]
    ]


whitepaper : String
whitepaper =
    "/papers/macho-obfuscation.pdf"
