module Route.Osx.Slug_ exposing (ActionData, Data, Model, Msg, route)

import Article
import BackendTask exposing (BackendTask)
import Date exposing (Date)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (style)
import Link exposing (Link)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Pages.Url
import PagesMsg exposing (PagesMsg)
import RouteBuilder exposing (App, StatelessRoute)
import Route
import Shared
import View exposing (View)


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
    { slug : String }


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.preRender
        { head = head
        , pages = pages
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


pages : BackendTask FatalError (List RouteParams)
pages =
    Article.osxPostsGlob
        |> BackendTask.map
            (List.map
                (\globData ->
                    { slug = globData.slug }
                )
            )


type alias Data =
    { metadata : ArticleMetadata
    , body : List Markdown.Block.Block
    }

type alias ActionData =
    {}


data : RouteParams -> BackendTask FatalError Data
data routeParams =
    MarkdownCodec.withFrontmatter Data
        frontmatterDecoder
        TailwindMarkdownRenderer.renderer
        ("content/osx/" ++ routeParams.slug ++ ".md")


type alias ArticleMetadata =
    { title : String
    , subtitle : String
    , description : String
    , published : Date
    -- , image : Pages.Url.Url
    , draft : Bool
    }


frontmatterDecoder : Decoder ArticleMetadata
frontmatterDecoder =
    Decode.map5 ArticleMetadata
        (Decode.field "title" Decode.string)
        (Decode.field "subtitle" Decode.string)
        (Decode.field "summary" Decode.string)
        (Decode.field "published"
            (Decode.string
                |> Decode.andThen
                    (\isoString ->
                        Date.fromIsoString isoString
                            |> Json.Decode.Extra.fromResult
                    )
            )
        )
        -- (Decode.oneOf
        --     [ Decode.field "image" imageDecoder
        --     , Decode.field "unsplash" UnsplashImage.decoder |> Decode.map UnsplashImage.imagePath
        --     ]
        -- )
        (Decode.field "draft" Decode.bool
            |> Decode.maybe
            |> Decode.map (Maybe.withDefault False)
        )

head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "nganhkhoa osx series"
        , image =
            { url = Pages.Url.external ""
            , alt = app.data.metadata.title
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = ""
        , locale = Nothing
        , title = app.data.metadata.title
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    let rendered = (app.data.body |> Markdown.Renderer.render TailwindMarkdownRenderer.renderer) |> Result.withDefault []
    in
    { title = app.data.metadata.title
    , body =
        [ Link.link (Link.internal (Route.Index))
            [ style "margin" "10px" ]
            [ text "Home" ]
        , Link.link (Link.internal (Route.Osx__Slug_ { slug = "" }))
            [ style "margin" "10px" ]
            [ text "OSX Index" ]
        , br [] []
        , h1 [] [ text app.data.metadata.title ]
        , div [] rendered
        ]
    }
