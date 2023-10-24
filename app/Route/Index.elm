module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled as Html
import Html.Styled.Attributes as Attributes
import Link exposing (Link)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import UrlPath
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import View exposing (View)


type alias Model =
    {}


type alias Msg =
    ()


type alias RouteParams =
    {}


type alias Data =
    { message : String
    }


type alias ActionData =
    {}


route : StatelessRoute RouteParams Data ActionData
route =
    RouteBuilder.single
        { head = head
        , data = data
        }
        |> RouteBuilder.buildNoState { view = view }


data : BackendTask FatalError Data
data =
    BackendTask.succeed Data
        |> BackendTask.andMap
            (BackendTask.succeed "Hello!")


head :
    App Data ActionData RouteParams
    -> List Head.Tag
head app =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = [ "images", "icon-png.png" ] |> UrlPath.join |> Pages.Url.fromPath
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Welcome to elm-pages!"
        , locale = Nothing
        , title = "elm-pages is running"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "Anh Khoa Nguyen"
    , body =
        [ Html.p []
            [ Html.text <| "Welcome to my personal website, where I post random things and thoughts."
            ]
        , Link.link (Link.internal (Route.Blog__Slug_ { slug = "" })) [] [ Html.text "Blogs" ]
        , Html.br [] []
        , Link.link (Link.internal (Route.Osx__Slug_ { slug = "" })) [] [ Html.text "OSX Series" ]
        , Html.br [] []
        , Html.text "Here is my CV:"
        , Link.link (Link.external cvpdf) [Attributes.target "_blank"] [Html.text "CV.pdf"]
        ]
    }

cvpdf : String
cvpdf = "cv.pdf"
