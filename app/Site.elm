module Site exposing (config)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import SiteConfig exposing (SiteConfig)


config : SiteConfig
config =
    { canonicalUrl = "https://nganhkhoa.com"
    , head = head
    }


head : BackendTask FatalError (List Head.Tag)
head =
    [ Head.metaName "viewport" (Head.raw "width=device-width,initial-scale=1")

    -- , Head.nonLoadingNode "link"
    --     [ ( "rel", Head.raw "stylesheet" )
    --     , ( "crossorigin", Head.raw "anonymous" )
    --     , ( "href", Head.raw "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" )
    --     ]
    -- , Head.nonLoadingNode "script"
    --     [ ( "crossorigin", Head.raw "anonymous" )
    --     , ( "href", Head.raw "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" )
    --     ]
    -- , Head.nonLoadingNode "script"
    --     [ ( "crossorigin", Head.raw "anonymous" )
    --     , ( "href", Head.raw "https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" )
    --     , ( "onload", Head.raw "renderMathInElement(document.body);" )
    --     ]
    ]
        |> BackendTask.succeed
