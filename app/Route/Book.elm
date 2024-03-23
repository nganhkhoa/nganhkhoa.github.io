module Route.Book exposing (ActionData, Data, Model, Msg, route)

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
        , siteName = "nganhkhoa recommended books"
        , image =
            { url = Pages.Url.external ""
            , alt = "nganhkhoa recommended books"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "Where to learn anything Computer"
        , locale = Nothing
        , title = "Computer Books"
        }
        |> Seo.website


view :
    App Data ActionData RouteParams
    -> Shared.Model
    -> View msg
view app shared =
    { title = "Computer Science Resources"
    , body =
        [ Link.link (Link.internal (Route.Index)) []
            [ text "Home" ]
        , div []
            [ p []
                [ text "While I was an undergraduate, I participated in many Capture The Flags (CTF) competitions. There are 4 main types of CTF challenge, and I was focusing on Reverse Engineering. This type of challenges requires the player to understand a given program, usually without source code. Through these challenges, I learned how programs are represented and executed in the machine code, and crucially how the Operating System works. Graduated, I continue working as a Security Engineer with a strong focus on executable binary innerworkings. Over the years, I also developed my interest in Programming Language Theory to bridge the gap between abstract model of programs to concrete binary representation and runtime modeling of programs. Although I do not have a strong background in algebra and number theory, a lot of my work requires me to understand components of cryptography and I am now also learning cryptography. As I keep learning, I am now starting to refer to books, and source code materials to learn. This site is a collection of resources that I would say the best of the best about Computer Science." ]
            , p []
                [ text "Before starting this list, I want to introduce readers to the philosophy that I frequently share whenever I teach anybody Computer Science. (1) Everything is Bytes; (2) Everything has a specification; (3) There is only one src/ of truth. (1) reminds us that in computer everything is binary and if we understand how the bits work together we understand how sophisticated software works. (2) reminds us that there is always a specification exists for the only purpose of helping people work together separately. (3) reminds us that if we want to understand what a software does we should read its source code not documentation." ]
            ]
        , div []
            [ h3 [] [ text "Operating System" ]
            , h4 [] [ text "Books" ]
            , p []
                [ text "OPERATING SYSTEMS: DESIGN AND IMPLEMENTATION"
                , br [] []
                , text "The book that Linus Torvalds read to learn and implement Linux."
                , br [] []
                , br [] []
                , text "Operating System Design - The XINU Approach"
                , br [] []
                , text "Book by Douglas Comer."
                , br [] []
                , br [] []
                , text "Essentials Of Computer Architecture"
                , br [] []
                , text "Book by Douglas Comer."
                ]
            , h4 [] [ text "Projects" ]
            , p []
                [ linkexternal "https://www.minix3.org/" "MINIX3"
                , br [] []
                , linkexternal "https://github.com/theseus-os/Theseus/" "Theseus"
                , br [] []
                , linkexternal "https://github.com/reactos/reactos" "ReactOS"
                , br [] []
                , linkexternal "https://github.com/torvalds/linux" "Linux"
                , br [] []
                , linkexternal "https://wiki.osdev.org/" "OSDev"
                ]
            ]
        , div []
            [ h3 [] [ text "Network" ]
            , h4 [] [ text "Books" ]
            , p []
                [ text "Internetworking With TCP/IP"
                , br [] []
                , text "Books by Douglas Comer. All 3 series."
                , br [] []
                , br [] []
                , text "The Internet Book: Everything you need to know about computer networking and how the Internet works"
                , br [] []
                , text "Book by Douglas Comer."
                ]
            , h4 [] [ text "Projects" ]
            , p []
                [ linkexternal "https://github.com/cloudflare/pingora" "Cloudflare's Pingora"
                ]
            ]
        , div []
            [ h3 [] [ text "Programming Languages and Compilers" ]
            , p []
                [ text "Programming Language Theory is my currently most interested part in Computer Science. Coming from a reverse engineer background, where I understand how program works by disecting their machine code, Programming Language Theory is something more abstract and more generic. Every software is built up from a series of complex theories. Building up from the concept of computation (Lambda Calculus), then values are lifted to types (Type Theory), then types are lifted to kinds (Higher-Kinded Types), and the many ways to concept objects in a program into mathematic objects (Algebraic Data Types, Algebraic Effect Handlers). There's also a wide range of research on process and its semantic (Operational Semantics), as well as how it should be performed (Process Calculi). People also starting to use logic to deduce the security of software (Hoare Logic, Incorrectness Logic, Reacability Logic). Generative programming is being explored in these few years back, where program can be generated (whole or some part) given a specification (Program Synthesis, Program Repair). Stray away from simple programs, distributed programs or domain-specific languages (DSL) are having huge surge in research focus." ]
            , p []
                [ text "Compilers are more direct to how programs should be when running in a machine. The concept is inherently simple, but it gets complicated as human created some sophisticated software. Currently, we all agree on the linearlity of programs, where flow of programs are linear from top to bottom. This linearlity puts many limitations and people started to find different ways to realize (run) the program. Right now, we have Bytecode Virtual Machine, Interpreter, Just in Time Compiler, Ahead of Time Compiler as solutions to a more dynamic and less-linear program. Why less-linear, because it depends on a controller that can direct how program works. This concept of linearlity is of my own and should NOT be viewed as theorectically correct." ]
            , h4 [] [ text "Books" ]
            , p [] [ text "These compiler books ranges from understanding the systematic approach of compilers to a more theoretical ones where type theory are used. Programming Language Theory books are more theoretic and provide foundations to many theories in programming language." ]
            , p []
                [ text "Compilers: Principles, Techniques, and Tools"
                , br [] []
                , text "Must read if you want to learn compiler technology. In the community, this book is referred to as the Dragon Book. The history of this book is from Red Dragon to Green Dragon to the current Purple Dragon."
                , br [] []
                , br [] []
                , text "Crafting Interpreters"
                , br [] []
                , text "A more direct and simple approach to learning how compiler works."
                , br [] []
                , br [] []
                , text "Essentials of Compilation"
                , br [] []
                , text "Books by Professor Jeremy G. Siek, the creator of Gradual Type. He has two verions of this book, one in Racket, one in Python. This book covers the core part of compilation and the target machine code is X86. This is to be the textbook for use in many schools in the future because the author is both a teacher and a programming language researcher."
                , br [] []
                , br [] []
                , text "Principles of Programming Languages"
                , br [] []
                , text "Book by Professors Mike Grant, Zachary Palmer, and Scott Smith. This book is more theoretic and contains the pure ML language then slowly through the chapters extended to more modern features of programming languages. The book is more focus on Type Theory and how types work."
                , br [] []
                , br [] []
                , text "Practical Foundations for Programming Languages"
                , br [] []
                , text "Book by Professors Robert Harper, one of the most influenced people in programming language theory development. This book is more inclined to its mathematical modeling of programs and types."
                , br [] []
                , br [] []
                , text "Types and Programming Languages"
                , br [] []
                , text "Books by Professors Benjamin C. Pierce, a student of Robert Harper. This book is one of the must read when studying programming language theory. Its successor, Advanced Topics in Types and Programming Languages, is also very helpful."
                , br [] []
                , br [] []
                , text "Software Foundations series"
                , br [] []
                , text "A series by multiple authors. This series focuses on the logical aspect of programs to build and verify software."
                ]
            , h4 [] [ text "Projects" ]
            , p []
                [ linkexternal "https://github.com/llvm/llvm-project" "LLVM"
                , br [] []
                , linkexternal "https://plzoo.andrej.com/" "Programming Language Zoo"
                ]
            ]
        , div []
            [ h3 [] [ text "Cryptography" ]
            , p [] [ text "One of the core components of computer system. Without cryptography, privacy and security might not be able to achieve. The core of cryptography lies in number theory and abstract algebra. Basically the study of numbers and their characteristics. We use these characteristics to build secured and private protocols." ]
            , h4 [] [ text "Books" ]
            , p [] [ text "Although number theory is the root of cryptography, the general topic is broader and books on this topic will not be mentioned. Books listed below are mainly cryptography and advanced usecases of cryptography." ]
            , p []
                [ text "A Graduate Course in Applied Cryptography"
                , br [] []
                , text "Book by Dan Boneh and Victor Shoup. A newer and more theoretic book on modern cryptography."
                , br [] []
                , br [] []
                , text "Proofs, Arguments, and Zero-Knowledge"
                , br [] []
                , text "Book by Justin Thaler. Textbook on Zero-Knowledge, a new branch of cryptography focuses on proving a (computation) claim with privacy."
                , br [] []
                , br [] []
                , text "A Pragmatic Introduction to Secure Multi-Party Computation"
                , br [] []
                , text "Book by David Evans, Vladimir Kolesnikov and Mike Rosulek. Textbook on Multi-Party Computation, a new branch of cryptography focuses on computing with multiple parties while maintaining privacy."
                ]
            ]
        ]
    }


linkexternal src title = Link.link (Link.external src) [Attributes.target "_blank"] [text title]
