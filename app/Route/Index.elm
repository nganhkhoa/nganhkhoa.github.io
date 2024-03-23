module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (style, target, src)
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
        [ div [ style "display" "flex", style "column-gap" "10px" ]
            [ quicklinks "github" "Github"
            , quicklinks "git" "Personal Git"
            , quicklinks "blog" "Blog Posts"
            , quicklinks "osx" "OSX series"
            , quicklinks "book" "My Recommended Books"
            , quicklinks "efiens" "Efiens Blogs"
            ]
        , br [] []
        , img [src "/nganhkhoa.png"] []
        , withSpacing (p [])
            [ text "Welcome to my personal website, where I post random things and thoughts."
            ]
        , withSpacing (p [])
            [ text "I'm a Security Engineer at"
            , quicklinks "bshield" "BShield"
            , text "and"
            , quicklinks "verichains" "Verichains"
            , text "Before that, I was a member of Efiens under the name"
            , quicklinks "efiens" "luibo."
            ]
        , withSpacing (p [])
            [ text "My specialty are in computer security: memory forensics, binary analysis, program analysis, and compiler."
            , text "My interest in computer systems are programming languages."
            , text "I am finding for opportunities in type theory, operational semantic, and formal methods."
            ]
        , withSpacing (p [])
            [ text "My Github is"
            , quicklinks "github" "nganhkhoa."
            , text "But I also maintain my personal git at"
            , quicklinks "git" "git.nganhkhoa.com."
            ]
        , text "You can find out more about me in my "
        , quicklinks "cv" "CV."
        , br [] []
        , text "I often write blogs, most of them are based on my research knowledge. "
        , text "You can find my blogs "
        , quicklinks "blog" "here."
        , br [] []
        , text "I also wrote a series about Mach-O binary format. You can find it "
        , quicklinks "osx" "here."
        , br [] []
        , text "I am a Vietnamese polyglot, fluent in English, conversational in Japanese, beginners in Mandarin and Korean."
        , withSpacing (p [])
            [ text "\"I use (neo)Vim and Arch, btw\" - probably me."
            , text "This site is written using"
            , quicklinks "elm" "elm-pages."
            ]
        , projects
        , br [] []
        , publications
        ]
    }

projects : Html msg
projects =
    div []
    [ h1 [] [text "My Projects"]
    , div []
        [ h2 [] [text "(2023) TSShock"]
        , withSpacing (p [])
            [ text "At Verichains, our team discovered multiple weaknesses in most implementations of Threshold ECDSA Signature Scheme following the works of"
            , quicklinks "gg" "Gennaro and Goldfeder."
            , text "As the result, we presented our findings at "
            , quicklinks "tsshockblackhat" "Black Hat USA 2023"
            , text "and"
            , quicklinks "tsshockhitb" "Hack In The Box Phuket 2023"
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
            , quicklinks "bshield" "BShield Secure-ID."
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
            , quicklinks "ollvm" "Obfuscator-LLVM"
            , text "with"
            , quicklinks "mba" "Mixed Boolean-Arithmetic"
            , text "as well as many other obfuscation passes."
            , text "Fully updated to LLVM 14 with support for both new and legacy pass manager."
            , text "A CTF challenge is released obfuscated using our obfuscator in"
            , quicklinks "tetctf2022" "TetCTF 2022"
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
            , quicklinks "poolscan" "Pool Tag Quick Scanning."
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
            , quicklinks "tsshockwebsite" "[website]"
            , quicklinks "tsshockwhitepaper" "[whitepaper]"
            , quicklinks "tsshockvideohitb" "[HITB Recordings]"
            ]
        , br [] []
        , withSpacing (div [])
            [ text "Obfuscate API calls in Mach-O Binary."
            , text "Anh Khoa Nguyen."
            , text "Expecting 2024."
            , br [] []
            , quicklinks "macho" "[preprint]"
            ]
        , br [] []
        , withSpacing (div [])
            [ text "Live Memory Forensics Without RAM Extraction."
            , text "Anh Khoa Nguyen, Dung Vo Van Tien."
            , text "Expecting 2024."
            , br [] []
            , quicklinks "live-memory-forensics" "[preprint]"
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
            , quicklinks "memorypoolscan" "[pdf]"
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
            , quicklinks "memoryinjection" "[pdf]"
            ]
        ]

quicklinks link title =
    let
        linkexternal src = Link.link (Link.external src) [target "_blank"] [text title]
        linkinternal src = case src of
            "blog" -> Link.link (Link.internal (Route.Blog__Slug_ { slug = "" })) [] [ text title ]
            "osx" -> Link.link (Link.internal (Route.Osx__Slug_ { slug = "" })) [] [ text title ]
            "book" -> Link.link (Link.internal Route.Book) [] [ text title ]
            _ -> Link.link (Link.external "") [] [text title]
    in
    case link of
        "github" -> linkexternal "https://github.com/nganhkhoa"
        "git" -> linkexternal "https://git.nganhkhoa.com"
        "efiens" -> linkexternal "https://blog.efiens.com/author/luibo"
        "bshield" -> linkexternal "https://bshield.io"
        "verichains" -> linkexternal "https://verichains.io"
        "elm" -> linkexternal "https://elm-pages.com"
        -- tsshock
        "gg" -> linkexternal "https://eprint.iacr.org/2019/114"
        "tsshockblackhat" -> linkexternal "https://www.blackhat.com/us-23/briefings/schedule/#tsshock-breaking-mpc-wallets-and-digital-custodians-for-billion-profit-33343"
        "tsshockhitb" -> linkexternal "https://conference.hitb.org/hitbsecconf2023hkt/session/tsshock-breaking-mpc-wallets-and-digital-custodians/"
        "tsshockwebsite" -> linkexternal "https://verichains.io/tsshock"
        "tsshockwhitepaper" -> linkexternal "https://www.verichains.io/tsshock/verichains-tsshock-wp-v1.0.pdf"
        "tsshockvideohitb" -> linkexternal "https://youtu.be/1ks2jcS7UE4"
        -- ollvm
        "ollvm" -> linkexternal "https://doi.org/10.1109/SPRO.2015.10"
        "mba" -> linkexternal "https://doi.org/10.1007/978-3-540-77535-5_5"
        "tetctf2023" -> linkexternal "https://twitter.com/hgarrereyn/status/1477919411977830402"
        -- memory forensics
        "poolscan" -> linkexternal "https://doi.org/10.1016/j.diin.2016.01.005"
        -- site resources
        "cv" -> linkexternal "cv.pdf"
        "blog" -> linkinternal "blog"
        "osx" -> linkinternal "osx"
        "book" -> linkinternal "book"
        -- pdfs
        "memorypoolscan" -> linkexternal "https://drive.google.com/file/d/1Z_cKtBsi_gm8ugsrnAEPo-Wmx9GAuaSK/view?usp=sharing"
        "memoryinjection" -> linkexternal "https://drive.google.com/file/d/1X18tr4OvcNYRoyxzTcsxM_MgjcqVW1sk/view?usp=sharing"
        "macho" -> linkexternal "macho-obfuscation.pdf"
        "live-memory-forensics" -> linkexternal "live-memory-forensics.pdf"
        _ -> linkexternal ""

