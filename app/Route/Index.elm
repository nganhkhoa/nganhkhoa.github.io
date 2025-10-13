module Route.Index exposing (ActionData, Data, Model, Msg, route)

import BackendTask exposing (BackendTask)
import FatalError exposing (FatalError)
import Head
import Head.Seo as Seo
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (class, src, style, target)
import Link exposing (Link)
import Pages.Url
import PagesMsg exposing (PagesMsg)
import Route
import RouteBuilder exposing (App, StatelessRoute)
import Shared
import UrlPath
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
        [ article [ class "paperlike" ]
            [ -- header
              h1 [] [ text "Me" ]
            , section []
                [ p []
                    [ text "I'm currently a M.S. C.S. student at Northwestern University. My research will be in Software Contracts under the supervision of"
                    , text " "
                    , quicklinks "https://users.cs.northwestern.edu/~chrdimo" "Professor Christos Dimoulas"
                    , text "."
                    ]
                , p []
                    [ text "I am also a Security Engineer at"
                    , text " "
                    , quicklinks "verichains" "Verichains"
                    , text " working on"
                    , text " "
                    , quicklinks "bshield" "BShield"
                    , text " for more than 5 years."
                    , span [ class "marginnote" ] [ img [ src "/nganhkhoa.png" ] [] ]
                    ]
                , p []
                    [ text "Before that, I was a member of"
                    , text " "
                    , quicklinks "efiens" "Efiens"
                    , label [ class "sidenote-number" ] []
                    , span [ class "sidenote" ] [ text "CTF team of Ho Chi Minh University of Technology, Vietnam. Our team has won prizes in national and international competitions. Founded 2016, inactive since 2021, superceeded by", text " ", quicklinks "bkisc" "BKISC", text "." ]
                    , text "."
                    ]
                ]
            , h1 [] [ text "Projects" ]
            , section []
                [ p []
                    [ text "I have worked on multiple technologies in Computer Science, including compliers, memory forensics, Windows internal, Linux system, NFC card, cryptography, binary formats. Across the years, I have gained experience working with large codebases."
                    , text ""
                    , label [ class "sidenote-number" ] []
                    , span [ class "sidenote" ] [ text "LLVM, Volatility, dyld3, objc4, QEMU" ]
                    , text " "
                    , text "The following list shows my past projects and contributions over the years."
                    ]
                , projects
                , publications
                , blabla
                ]
            ]
        ]
    }


projects : Html msg
projects =
    div []
        [ section []
            [ h2 [] [ text "AIxCC finals contributions" ]
            , p []
                [ text "I was invited to collaborate on team "
                , quicklinks "https://b3yond.org/team" "42-b3yond-6ug"
                , text " led by "
                , quicklinks "http://xinyuxing.org/" "Professor Xinyu Xing"
                , text " for "
                , quicklinks "https://aicyberchallenge.com/" "AIxCC"
                , text " finals."
                , text " My task was to develop a Call Graph for C/C++ source projects from LLVM bitcode produced during compilation. The result is later fed to a directed fuzzer for other pipelines."
                ]
            ]
        , section []
            [ h2 [] [ text "TSSHOCK" ]
            , p []
                [ text "I was a part of the team that helped unveiling the vulnerabilities in many implementations of ECDSA Threshold Signature Scheme protocol by Gennaro and Goldfeder"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ] [ text "In public key cryptosystem, signing messages usually involves one party with one private key. Threshold Signature Scheme allows more than one party to participate to the signing process while keeping only one private key used. Missing a signing party would be impossible to sign messages. Across the whole process, the private key is kept unknown to all parties. Gennaro and Goldfeder (GG18/GG20) proposed a protocol, which is now superceeded by MPC-CMP." ]
                , text "."
                , text " "
                , text "Our findings was publicly announced and published at two major security conventions,"
                , text " "
                , quicklinks "tsshockblackhat" "Black Hat USA 2023"
                , text " "
                , text "and"
                , text " "
                , quicklinks "tsshockhitb" "Hack In The Box Phuket 2023"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Duy Hieu Nguyen, Anh Khoa Nguyen, Huu Giap Nguyen, Thanh Nguyen and Anh Quynh Nguyen. TSSHOCK: Breaking MPC Wallets and Digital Custodians for $BILLION$ Profit. 2023"
                    ]
                , text "."
                ]
            ]
        , section []
            [ h2 [] [ text "Vietnam Citizen Card Audits" ]
            , p []
                [ text "I was working on an application using our country citizen card when I realized that many (in production) NFC eKYC applications might not working properly because they lack the understanding of cryptographic protocols required for securely communication with the NFC card. My team and I built a simulation device for the ICAO 9303"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Doc 9303: Machine Readable Travel Documents. ICAO."
                    ]
                , text " "
                , text "and conducted security analysis of government applications."
                ]
            ]
        , section []
            [ h2 [] [ text "Research Mach-O binary format" ]
            , p []
                [ text "Mach-O is the binary format used exclusively in Apple devices. I started researching about this format when I first joined BShield. I had an idea back then about how we can simulate the loader to control imports. Years later, I build a Proof of Concept around the idea. Using loader simulation, we can build an obfuscator or a hooking tool. Details are disclosed in the paper."
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Anh Khoa Nguyen and Thien Nhan Nguyen. Simulating Loader for Mach-O Binary Obfuscation and Hooking."
                    ]
                ]
            ]
        , section []
            [ h2 [] [ text "LLVM based Obfuscation" ]
            , p []
                [ text "I fork and built an obfuscator based on LLVM, first mentioned in Obfuscator-LLVM"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Pascal Junod and Julien Rinaldini and Johan Wehrli and Julie Michielin. Obfuscator-LLVM -- Software Protection for the Masses. 2015."
                    ]
                , text "."
                , text " "
                , text "With my team, we ported Mixed Boolean-Arithmetic"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Yongxin Zhou, Alec Main, Yuan X. Gu, and Harold Johnson. Information Hiding in Software with Mixed Boolean-Arithmetic Transforms. In Proceedings of the 8th International Conference on Information Security Applications (WISA’07), 2007."
                    ]
                , text " "
                , text "to be used in the obfuscator, which has not been previously discussed in the original implementation of Obfuscator-LLVM. Other ideas were also implemented. We also update to use LLVM 14, with the support for new pass manager alongside the legacy pass manager. A CTF challenge was released obfuscated using this obfuscator in"
                , text " "
                , quicklinks "tetctf2022" "TetCTF 2022"
                , text "."
                ]
            ]
        , section []
            [ h2 [] [ text "Windows Live Memory Forensics" ]
            , p []
                [ text "My first research project started as a bachelor thesis. I built a memory forensics tool working on virtual memory. For the success of this project, I have learned Windows kernel driver, memory forensics techniques, and studied the Volatility source code. The prototype was capable of inspecting the kernel memory, viewing kernel global variables, and perform Pool Tag Quick Scanning"
                , label [ class "sidenote-number" ] []
                , span [ class "sidenote" ]
                    [ text "Joe T. Sylve, Vico Marziale, Golden G. Richard. Pool tag quick scanning for windows memory analysis. 2016."
                    ]
                , text "."
                , text " "
                , text "The work is later improved to search for code injection by Vo Van Tien Dung."
                ]
            ]
        ]


publications : Html msg
publications =
    section []
        [ h1 [] [ text "Publications" ]
        , p []
            [ text "Most of my publications are drafts and not reviewed paper. Because I am not in an academic environment so I do not know how to publish."
            ]
        , withSpacing (p [])
            [ text "Simulating Loader for Mach-O Binary Obfuscation and Hooking."
            , text "Anh Khoa Nguyen, Thien Nhan Nguyen."
            , text "(Submitted, rejected, paper for free views)"
            , br [] []
            , quicklinks "macho" "[preprint]"
            , quicklinks "macho-git" "[git]"
            ]
        , withSpacing (p [])
            [ text "Live Memory Forensics on Virtual Memory."
            , label [ class "sidenote-number" ] []
            , span [ class "sidenote" ] [ text "Nguyen, K.A., Vo-Van, TD., Nguyen, AQ., Nguyen-Le, T., Le, DT., Nguyen-An, K. (2024). Live Memory Forensics on Virtual Memory. In: Dang, T.K., Küng, J., Chung, T.M. (eds) Future Data and Security Engineering. Big Data, Security and Privacy, Smart City and Industry 4.0 Applications. FDSE 2024. Communications in Computer and Information Science, vol 2310. Springer, Singapore. https://doi.org/10.1007/978-981-96-0437-1_3" ]
            , text "Nguyen, K.A., Vo-Van, TD., Nguyen, AQ., Nguyen-Le, T., Le, DT., Nguyen-An, K. (2024)."
            , br [] []
            , quicklinks "live-memory-forensics" "[pdf]"
            , quicklinks "live-memory-forensics-fdse" "[FDSE2024]"
            ]
        , withSpacing (p [])
            [ text "New Key Extraction Attackson Threshold ECDSA Implementations."
            , text "Duy Hieu Nguyen, Anh Khoa Nguyen, Huu Giap Nguyen, Thanh Nguyen, Anh Quynh Nguyen."
            , text "August 2023."
            , br [] []
            , quicklinks "tsshockwebsite" "[website]"
            , quicklinks "tsshockwhitepaper" "[whitepaper]"
            , quicklinks "tsshockvideoblackhat" "[Black Hat Recordings]"
            , quicklinks "tsshockvideohitb" "[HITB Recordings]"
            ]
        , br [] []
        , h2 [] [ text "Dissertations" ]
        , withSpacing (p [])
            [ text "My B.Eng. thesis"
            ]
        , withSpacing (p [])
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
        , withSpacing (p [])
            [ text "After I graduated, I often advise undergraduate students on their dissertations. The list below contains dissertations I co-advised."
            ]
        , withSpacing (p [])
            [ text "Emulating EMV cards with Android devices"
            , br [] []
            , text "Author: Nguyen Thien Nhan."
            , br [] []
            , text "Advisors: An Khuong Nguyen, Anh Khoa Nguyen."
            , br [] []
            , text "Year: 2025"
            , br [] []
            , quicklinks "emulatingemv" "[pdf]"
            ]
        , withSpacing (p [])
            [ text "Static binary repairing with code insertion"
            , br [] []
            , text "Author: Pham Nguyen Nam."
            , br [] []
            , text "Advisors: An Khuong Nguyen, Anh Khoa Nguyen."
            , br [] []
            , text "Year: 2025"
            , br [] []
            , quicklinks "elfinjection" "[pdf]"
            ]
        , withSpacing (p [])
            [ text "Sandboxing Powershell scripts for ransomware detection"
            , br [] []
            , text "Author: Do Dinh Phu Quy."
            , br [] []
            , text "Advisors: An Khuong Nguyen, Anh Khoa Nguyen, Vo Van Tien Dung."
            , br [] []
            , text "Year: 2024"
            , br [] []
            , quicklinks "powershellsandbox" "[pdf]"
            ]
        , withSpacing (p [])
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


blabla : Html msg
blabla =
    section []
        [ h1 [] [ text "Extras" ]
        , p []
            [ text "This webpage is written in Elm, using the design inspired by Tufte. Elm is a frontend framework with the syntax of Haskell, inspired (probably) by Yew. Though, I do not write the whole webpage, the logic for parsing the Markdown and building a static site is provided by Elm Pages. Tufte presentation design is very easy to read and follow. I usually read papers and (PhD) thesis written traditionally and found out that the reading is hard to follow when references are introduced. When reading Ralf Jung's PhD"
            , text " "
            , quicklinks "https://research.ralfj.de/thesis.html" "thesis"
            , label [ class "sidenote-number" ] []
            , span [ class "sidenote" ] [ text "Jung, Ralf. Understanding and evolving the Rust programming language. 2020." ]
            , text ","
            , text " "
            , text "I amazed how clean the text was due to all the references are introduced at the right side. Later that I found out the format was based on Tufte design and began using it for this website."
            ]
        , p []
            [ text "I use Neovim, can't live without those Vim motions. Neovim GUI that I use is"
            , text " "
            , quicklinks "https://neovide.dev/" "Neovide"
            , text ","
            , text " "
            , text "which I have also contributed."
            ]
        , p []
            [ text "I like to learn languages. I have achieved JLPT N2 for Japanese and working on my Chinese and Korean."
            ]
        , p []
            [ text "Besides tech work, I play the Piano and skate. I am not classically trained on Piano, but I am trying my Beethoven's Piano Sonatas. I just took up (Inline and Ice) skating recently and I've been having a great time with it."
            ]
        ]


quicklinks link title =
    let
        linkexternal src =
            Link.link (Link.external src) [ target "_blank" ] [ text title ]

        linkinternal src =
            case src of
                "blog" ->
                    Link.link (Link.internal (Route.Blog__Slug_ { slug = "" })) [] [ text title ]

                "osx" ->
                    Link.link (Link.internal (Route.Osx__Slug_ { slug = "" })) [] [ text title ]

                "book" ->
                    Link.link (Link.internal Route.Book) [] [ text title ]

                _ ->
                    Link.link (Link.external "") [] [ text title ]
    in
    case link of
        "github" ->
            linkexternal "https://github.com/nganhkhoa"

        "git" ->
            linkexternal "https://git.nganhkhoa.com"

        "efiens" ->
            linkexternal "https://blog.efiens.com/author/luibo"

        "bshield" ->
            linkexternal "https://bshield.io"

        "verichains" ->
            linkexternal "https://verichains.io"

        "bkisc" ->
            linkexternal "https://bkisc.com/"

        "elm" ->
            linkexternal "https://elm-pages.com"

        -- tsshock
        "gg" ->
            linkexternal "https://eprint.iacr.org/2019/114"

        "tsshockblackhat" ->
            linkexternal "https://www.blackhat.com/us-23/briefings/schedule/#tsshock-breaking-mpc-wallets-and-digital-custodians-for-billion-profit-33343"

        "tsshockhitb" ->
            linkexternal "https://conference.hitb.org/hitbsecconf2023hkt/session/tsshock-breaking-mpc-wallets-and-digital-custodians/"

        "tsshockwebsite" ->
            linkexternal "https://verichains.io/tsshock"

        "tsshockwhitepaper" ->
            linkexternal "https://www.verichains.io/tsshock/verichains-tsshock-wp-v1.0.pdf"

        "tsshockvideohitb" ->
            linkexternal "https://youtu.be/1ks2jcS7UE4"

        "tsshockvideoblackhat" ->
            linkexternal "https://youtu.be/5mlQb8PEF3A"

        -- ollvm
        "ollvm" ->
            linkexternal "https://doi.org/10.1109/SPRO.2015.10"

        "mba" ->
            linkexternal "https://doi.org/10.1007/978-3-540-77535-5_5"

        "tetctf2022" ->
            linkexternal "https://twitter.com/hgarrereyn/status/1477919411977830402"

        -- memory forensics
        "poolscan" ->
            linkexternal "https://doi.org/10.1016/j.diin.2016.01.005"

        -- site resources
        "cv" ->
            linkexternal "/cv.pdf"

        "blog" ->
            linkinternal "blog"

        "osx" ->
            linkinternal "osx"

        "book" ->
            linkinternal "book"

        -- pdfs
        "memorypoolscan" ->
            linkexternal "https://drive.google.com/file/d/1Z_cKtBsi_gm8ugsrnAEPo-Wmx9GAuaSK/view?usp=sharing"

        "memoryinjection" ->
            linkexternal "https://drive.google.com/file/d/1X18tr4OvcNYRoyxzTcsxM_MgjcqVW1sk/view?usp=sharing"

        "powershellsandbox" ->
            linkexternal "https://drive.google.com/file/d/1Fm1YVAxD-A-zjVvRwBPa-IhZ1Y8ImEyv/view?usp=sharing"

        "emulatingemv" ->
            linkexternal "https://drive.google.com/file/d/1n9GO2YHGaYsRGnViEJ2Bn22lZpF_s9fR/view?usp=drive_link"

        "elfinjection" ->
            linkexternal "https://drive.google.com/file/d/1e4qtoPm-FMnvUDUO09g1IDdjurpfIpJs/view?usp=drive_link"

        "macho" ->
            linkexternal "/papers/macho-obfuscation.pdf"

        "macho-git" ->
            linkexternal "https://github.com/nganhkhoa/macho-research"

        "live-memory-forensics" ->
            linkexternal "/papers/live-memory-forensics.pdf"

        "live-memory-forensics-fdse" ->
            linkexternal "https://doi.org/10.1007/978-981-96-0437-1_3"

        _ ->
            linkexternal link
