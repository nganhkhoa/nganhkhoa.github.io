module Header exposing (header)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (style, target, src, class)

import Route
import Link exposing (Link)

header = p [ style "display" "flex", style "flex-direction" "row", style "justify-content" "flex-start" ]
    [ p [ style "margin-right" "1rem" ] [ home ]
    , p [ style "margin-right" "1rem" ] [ blog ]
    , p [ style "margin-right" "1rem" ] [ book ]
    ]

home = Link.link (Link.internal (Route.Index)) [] [ text "Home" ]
blog = Link.link (Link.internal (Route.Blog__Slug_ { slug = "" })) [] [ text "Blog" ]
book = Link.link (Link.internal (Route.Book)) [] [ text "Book" ]
