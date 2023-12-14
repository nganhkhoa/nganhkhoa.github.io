module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
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
        , siteName = "nganhkhoa.com"
        , image =
            { url = "https://nganhkhoa.com/nganhkhoa.png" |> Pages.Url.external
            , alt = "nganhkhoa"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Personal blog of nganhkhoa"
        , locale = Nothing
        , title = "Anh Khoa Nguyen"
        }
        |> Seo.website


withSpacing : (List (Html msg) -> Html msg) -> List (Html msg) -> Html msg
withSpacing element =
    List.intersperse (text " ") >> element

view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View (PagesMsg Msg)
view app shared =
    { title = "nganhkhoa"
    , body =
        [ img [Attributes.src "/nganhkhoa.png"] []
        , withSpacing (p [])
            [ text "Welcome to my personal website, where I post random things and thoughts."
            ]
        , withSpacing (p [])
            [ text "I'm a Security Engineer at"
            , Link.link (Link.external "https://bshield.io") [Attributes.target "_blank"] [text "BShield"]
            , text "and"
            , Link.link (Link.external "https://verichains.io") [Attributes.target "_blank"] [text "Verichains."]
            , text "Before that, I was a member of Efiens under the name"
            , Link.link (Link.external "https://blog.efiens.com/author/luibo/") [] [text "luibo."]
            ]
        , withSpacing (p [])
            [ text "My specialty are in computer security: memory forensics, binary analysis, program analysis, and compiler."
            , text "My interest in computer systems are programming languages."
            , text "I am finding for opportunities in type theory, operational semantic, and formal methods."
            ]
        , withSpacing (p [])
            [ text "My Github is"
            , Link.link (Link.external "https://github.com/nganhkhoa") [Attributes.target "_blank"]
                [text "nganhkhoa."]
            , text "But I also maintain my personal git at"
            , Link.link (Link.external "https://git.nganhkhoa.com/nganhkhoa") [Attributes.target "_blank"]
                [text "git.nganhkhoa.com."]
            ]
        , text "You can find out more about me in my "
        , Link.link (Link.external cvpdf) [Attributes.target "_blank"] [text "CV."]
        , br [] []
        , text "I often write blogs, most of them are based on my research knowledge."
        , text "You can find my blogs "
        , Link.link (Link.internal (Route.Blog__Slug_ { slug = "" })) [] [ text "here." ]
        , br [] []
        , text "I also wrote a series about Mach-O binary format."
        , text "You can find it "
        , Link.link (Link.internal (Route.Osx__Slug_ { slug = "" })) [] [ text "here." ]
        , br [] []
        , text "I am a Vietnamese polyglot, fluent in English, conversational in Japanese, beginners in Mandarin and Korean."
        , withSpacing (p [])
            [ text "\"I use (neo)Vim and Arch, btw\" - probably me."
            , text "This site is written using"
            , Link.link (Link.external "https://elm-pages.com/") [] [ text "elm-pages." ]
            ]
        , projects
        , br [] []
        , publications
        ]
    }

cvpdf : String
cvpdf = "cv.pdf"

projects : Html msg
projects =
    div []
    [ h1 [] [text "My Projects"]
    , div []
        [ h2 [] [text "(2023) TSShock"]
        , withSpacing (p [])
            [ text "At Verichains, our team discovered multiple weaknesses in most implementations of Threshold ECDSA Signature Scheme following the works of"
            , Link.link (Link.external "https://eprint.iacr.org/2019/114") [] [text "Gennaro and Goldfeder."]
            , text "As the result, we presented our findings at "
            , Link.link (Link.external "https://www.blackhat.com/us-23/briefings/schedule/#tsshock-breaking-mpc-wallets-and-digital-custodians-for-billion-profit-33343") [] [text "Black Hat USA 2023"]
            , text "and"
            , Link.link (Link.external "https://conference.hitb.org/hitbsecconf2023hkt/session/tsshock-breaking-mpc-wallets-and-digital-custodians/") [] [text "Hack In The Box Phuket 2023"]
            , text "titled \"TSSHOCK: Breaking MPC Wallets and Digital Custodians for $BILLION$ Profit\"."
            ]
        ]
    , div []
        [ h2 [] [text "(2023) Audited Vietnam Citizen Card"]
        , withSpacing (p [])
            [ text "Performed auditing of the protocol and the chip-based Citizen Card of Vietnam."
            , text "Simulation of NFC protocols conforming to ICAO 9303."
            , text "Found several vulnerabilities in applications verifying the authenticity of these cards."
            , text "Government applications and devices are also audited."
            , text "The foundation research for the development of"
            , Link.link (Link.external "https://bshield.io/") [] [text "BShield Secure-ID."]
            ]
        ]
    , div []
        [ h2 [] [text "(2019 - 2023) Mach-O binary format analysis and obfuscation"]
        , withSpacing (p [])
            [ text "Research into Mach-O binary format, which is used in Apple devices."
            , text "Proposed obfuscation for the Mach-O binary."
            , text "Familiar with tools for pentesting iOS applications."
            ]
        ]
    , div []
        [ h2 [] [text "(2021-2022) LLVM based Obfuscation"]
        , withSpacing (p [])
            [ text "Build a LLVM based obfuscation compiler."
            , text "Extend"
            , Link.link (Link.external "https://doi.org/10.1109/SPRO.2015.10")
                [] [text "Obfuscator-LLVM"]
            , text "with"
            , Link.link (Link.external "https://doi.org/10.1007/978-3-540-77535-5_5")
                [] [text "Mixed Boolean-Arithmetic"]
            , text "as well as many other obfuscation passes."
            , text "Fully updated to LLVM 14 with support for both new and legacy pass manager."
            , text "A CTF challenge is released obfuscated using our obfuscator in"
            , Link.link (Link.external "https://twitter.com/hgarrereyn/status/1477919411977830402")
                [] [text "TetCTF 2022"]
            ]
        ]
    , div []
        [ h2 [] [text "(2019-2023) Windows Live Memory Forensics"]
        , withSpacing (p [])
            [ text "Research into Windows Forensics."
            , text "Learned techniques used in Memory Forensics and familiar with tools like Volatility."
            , text "Develope a new method for Live Forensics using Memory Forensics without Memory Extraction."
            , text "A prototype is implemented, capable of inspecting the kernel global variables, structures,"
            , text "and performing"
            , Link.link (Link.external "https://doi.org/10.1016/j.diin.2016.01.005")
                [] [text "Pool Tag Quick Scanning."]
            , text "This prototype is updated in 2023 to also detect injected code in processes for detection of"
            , text "DLL Injection, Reflective DLL Injection, Process Hollowing, and similar malware techniques."
            ]
        ]
    ]

publications : Html msg
publications =
    div []
        [ h1 [] [text "Publications"]
        , text "Most of my publications are drafts and not reviewed paper."
        , text " "
        , text "Because I am not in an academic environment so I do not know how to publish."
        , br [] []
        , br [] []
        , withSpacing (div [])
            [ text "New Key Extraction Attackson Threshold ECDSA Implementations."
            , text "Duy Hieu Nguyen, Anh Khoa Nguyen, Huu Giap Nguyen, Thanh Nguyen, Anh Quynh Nguyen."
            , text "August 2023."
            , br [] []
            , Link.link (Link.external "https://verichains.io/tsshock") [] [text "[website]"]
            , Link.link (Link.external "https://www.verichains.io/tsshock/verichains-tsshock-wp-v1.0.pdf")
                [Attributes.target "_blank"]
                [text "[whitepaper]"]
            , Link.link (Link.external "https://youtu.be/1ks2jcS7UE4") [] [text "[HITB Recordings]"]
            ]
        , br [] []
        , withSpacing (div [])
            [ text "Obfuscate API calls in Mach-O Binary."
            , text "Anh Khoa Nguyen."
            , text "Expecting 2024."
            , br [] []
            , Link.link (Link.external "macho-obfuscation.pdf")
                [Attributes.target "_blank"]
                [text "[preprint]"]
            ]
        , br [] []
        , withSpacing (div [])
            [ text "Live Memory Forensics Without RAM Extraction."
            , text "Anh Khoa Nguyen, Dung Vo Van Tien."
            , text "Expecting 2024."
            , br [] []
            , Link.link (Link.external "live-memory-forensics.pdf")
                [Attributes.target "_blank"]
                [text "[preprint]"]
            ]
        , br [] []
        , h2 [] [text "Dissertations"]
        , withSpacing (p [])
            [ text "After I graduated, I often advise undergraduate students on their dissertations."
            , text "The list below contains my dissertation and dissertations I advised."
            ]
        , withSpacing (div [])
            [ text "Windows Memory Forensics: Finding hidden processes in a running machine."
            , br [] []
            , text "Author: Anh Khoa Nguyen."
            , br [] []
            , text "Advisors: An Khuong Nguyen, Le Thanh Nguyen, Quoc Bao Nguyen."
            , br [] []
            , text "Year: 2020"
            , br [] []
            , Link.link (Link.external "https://drive.google.com/file/d/1Z_cKtBsi_gm8ugsrnAEPo-Wmx9GAuaSK/view?usp=sharing")
                [Attributes.target "_blank"]
                [text "[pdf]"]
            ]
        , br [] []
        , withSpacing (div [])
            [ text "Windows Memory Forensics: Detecting hidden injected code in a process."
            , br [] []
            , text "Author: Vo Van Tien Dung."
            , br [] []
            , text "Advisors: An Khuong Nguyen, Anh Khoa Nguyen."
            , br [] []
            , text "Year: 2023"
            , br [] []
            , Link.link (Link.external "https://drive.google.com/file/d/1X18tr4OvcNYRoyxzTcsxM_MgjcqVW1sk/view?usp=sharing")
                [Attributes.target "_blank"]
                [text "[pdf]"]
            ]
        ]
