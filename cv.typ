// ==========================================
// 1. SETUP & FUNCTIONS
// ==========================================

#set page(
  paper: "us-letter",
  margin: (x: 0.5in, y: 0.5in),
)
#set text(font: "New Computer Modern", size: 10pt)
#set par(justify: true)
#show link: set text(fill: blue, style: "italic")

// --- The Header Function ---
#let cv-header(col1, col2, col3) = {
  grid(
    columns: (1fr, 1fr, 1fr),
    align: (left, center, right),
    col1,
    block(width: auto, align(left, col2)),
    block(width: auto, align(left, col3))
  )
  v(1em)
}

// --- The Description Function ---
#let cv-description(summary, skills) = {
  grid(
    columns: (1fr, 1fr), // Left column takes 75% width
    gutter: 4em,
    align(left, summary),
    align(left, skills)
  )
  v(1em)
}

// --- The Section Function ---
#let cv-section(name) = {
  v(0.5em)
  grid(
    columns: (auto, 1fr), // Auto width for text, 1fr for line
    gutter: 0.5em,        // Small gap between text and line
    align(horizon, text(weight: "bold", size: 1.2em, upper(name))),
    align(horizon, line(length: 100%, stroke: 0.5pt))
  )
  // v(0.5em)
}

// --- The Subsection Function ---
#let cv-subsection(
  title: "",
  subtitle: "",
  extra: "",
  description: none
) = {
  block(breakable: false)[
    #grid(
      columns: (auto, 1fr, auto),
      gutter: 1em,
      strong(title),
      align(left, emph(subtitle)),  // Uses global 'left' alignment
      align(right, extra)       // Uses global 'right' alignment
    )
    #if description != none {
      pad(
        top: 0em,
        bottom: 0.3em,
        left: 1em,
        text(
          fill: rgb("#333333"), // <--- Softer dark gray color
          size: 0.95em,         // <--- Slightly smaller text
          description
        )
      )
    }
  ]
}

#let cv-list(items) = {
  for item in items {
    cv-subsection(
      title: item.at("title", default: ""),
      subtitle: item.at("subtitle", default: ""),
      extra: item.at("extra", default: ""),
      description: item.at("description", default: none)
    )
  }
}

#let tag(text, color: rgb("#008000")) = {
  box(
    fill: color.lighten(90%), // Very light background
    stroke: 0.5pt + color,    // Solid border
    inset: (x: 3pt, y: 3pt),  // Internal padding
    radius: 2pt,              // Rounded corners
    baseline: 20%,            // Aligns box with text
    outset: 0pt
  )[
    #text
  ]
}

// ==========================================
// 2. DOCUMENT CONTENT
// ==========================================

// --- Header Section ---
#cv-header(
  [
    *Anh Khoa NGUYEN* \
    Security Software Engineer \
    _US #text(fill: rgb("#00A000"))[Green Card] Status_
  ],
  [
    #link("mailto:ng.akhoa98@gmail.com")[ng.akhoa98\@gmail.com] \
    (+1) 872-262-3174 \
    Chicago, IL, US
  ],
  [
    #link("https://nganhkhoa.github.io")[nganhkhoa.github.io] \
    #link("https://github.com/nganhkhoa")[github.com/nganhkhoa]
  ]
)

// --- Short Description ---
#cv-description(
  text(hyphenate: false)[
    #cv-section("Summary")

    A M.S. CS student looking for PhD opportunities in Programming Language
    Theory and Computer Security. I believe that the future of programming is by building
    languages with #text(weight: "bold", style: "italic", fill: rgb("#F26035"))[first-class security].
    Personal interest includes an intersection of System Security, Cryptography, and PL Theory.

    Before my Master, I worked as a Software Security Engineer and
    Researcher at Verichains. During my tenure, my team and I have conducted
    multiple security research, some of which were presented
    at Blackhat, and Hack in the Box.
  ],
  [
    #cv-section("Skills")

    #grid(
      columns: (auto, 1fr),
      gutter: 1em,
      [*Programming*],
      [OCaml, C/C++, Golang, Rust, Python, Javascript],
      [*Typesetting*],
      [LaTeX, Typst],
      [*Technologies*],
      [Linux, Docker, QEMU, LLVM, #linebreak() AWS Cloud, PLT Redex],
      [*Languages*],
      [
        #grid(
          columns: (auto, auto),
          gutter: 1em,
          [Vietnamese], [Native],
          [English], [Professional],
          [Japanese], [Work Proficient],
        )
      ],
    )
  ]
)

// --- Body ---

#cv-section("Education")
#cv-list((
  (
    title: "M.S. in Computer Science",
    subtitle: "Northwestern University, IL, US",
    extra: text()[(GPA: 4.0/4.0) #h(2em) 2025 -- 12/2026],
    description: [
      Programming Language Research under #link("https://users.cs.northwestern.edu/~christos/")[Professor Christos Dimoulas] on software contracts.

      Thesis: #link("https://nganhkhoa.github.io/master-thesis/default.pdf")[Contracts Checking as an Effect].
    ]
  ),
  (
    title: "B.Eng. in Computer Science",
    subtitle: "Ho Chi Minh City University of Technology, Vietnam",
    extra: "2016 -- 2020",
  )
))

#cv-section("Experience")
#cv-list((
  (
    title: "Senior Security Engineer",
    subtitle: "Verichains",
    extra: "2019 -- 2025",
    description: [
      - Android and iOS security research
      - Web3 security research
      - Technical support
    ]
  ),
))

#cv-section("Publications")
#cv-list((
  (
    title: "Direct Kernel Virtual Address Space Forensics for Live Memory Analysis",
    subtitle: [
      SN Computer Science
      // #tag("Q2", color: rgb("#008000"))
    ],
    extra: "2025",
    description: [
      *Anh-Khoa Nguyen*, Tien-Dung Vo-Van, Anh-Quynh Nguyen, Thanh Nguyen-Le, Dinh-Thuan Le & Khuong Nguyen-An
      #linebreak()
      #link("https://doi.org/10.1007/s42979-025-04514-z")[10.1007/s42979-025-04514-z]
      #h(0.5em)
    ]
  ),
  (
    title: "Live Memory Forensics on Virtual Memory",
    subtitle: "FDSE",
    extra: "2024",
    description: [
      *Khoa A. Nguyen*, Tien-Dung Vo-Van, Anh-Quynh Nguyen, Thanh Nguyen-Le, Dinh-Thuan Le & Khuong Nguyen-An
      #linebreak()
      #link("https://doi.org/10.1007/978-981-96-0437-1_3")[10.1007/978-981-96-0437-1_3"]
      #h(0.5em)
    ]
  ),
  (
    title: "New Key Extraction Attacks on Threshold ECDSA Implementations",
    subtitle: "Blackhat USA",
    extra: "2023",
    description: [
      Duy Hieu Nguyen, *Anh Khoa Nguyen*, Huu Giap Nguyen, Thanh Nguyen, Anh Quynh Nguyen
      #linebreak()
      #link("https://www.verichains.io/tsshock/verichains-tsshock-wp-v1.0.pdf")[verichains.io/tsshock]
    ]
  ),
  (
    title: "Simulating Loader for Mach-O Binary Obfuscation and Hooking",
    subtitle: "Technical Report",
    description: [
      *Anh Khoa Nguyen*, Thien Nhan Nguyen
      #linebreak()
      #link("https://drive.google.com/file/d/1LldI6VEGbvdXiSQP5u2s5cDJNlVg77dz/view?usp=sharing")[drive.google.com/file/d/1LldI6VEGbvdXiSQP5u2s5cDJNlVg77dz/view?usp=sharing]
    ]
  ),
))

#v(5em)
#cv-section("Projects")
#cv-list((
  (
    title: "LLVM Bitcode to Program Call Graph for C/C++",
    subtitle: [
      #link("https://aicyberchallenge.com/")[AIxCC DARPA Challenge]
    ],
    extra: "2025",
    description: [
      Generate program call graph for C/C++ projects from LLVM bitcode. \
      Works for new LLVM versions with *Opaque Pointer*. \
      Contributed to team #link("https://b3yond.org/team")[42-b3yond-6ug]. \
      #tag("C++") #tag("LLVM")
    ]
  ),
  (
    title: "BShield API Protection Plugin",
    description: [
      Implemented API Protection plugins for multiple Gateway/Proxy frameworks. \
      Supports: NGINX, Apache, Kong, HAProxy, APISIX, Envoy, Spring/Websphere, Express \
      Protected millions of (banking) transactions across multiple banks in Vietnam \
      #tag("C++") #tag("Golang") #tag("Java") #tag("Lua")
    ]
  ),
  (
    title: "BShield Box",
    subtitle: "Custom Linux Distribution",
    description: [
      Self-contained Linux distribution for BShield solution \
      Deployable in AWS EC2 \
      #tag("Linux") #tag("QEMU") #tag("AWS")
    ]
  ),
  (
    title: "TSSHOCK: Private key recovery for libraries implementing Threshold ECDSA",
    extra: "2023",
    description: [
      GG18/GG20 implementations vulnerabilities discovered \
      Blackhat USA 2023 disclosure \
      #tag("Cryptography")
    ]
  ),
  (
    title: "Citizen Card Security Audits",
    subtitle: "NFC Security",
    extra: "2023",
    description: [
      Implemented emulator for ICAO 9303 using Android Host-based Card Emulation \
      #tag("Android") #tag("NFC")
    ]
  ),
))

#cv-section("Talks")
#cv-list((
  (
    title: "Critical Zero-Knowledge Proof Forgery Attack on zkEVM",
    subtitle: "Blackhat MEA",
    extra: "2024",
    description: [
      #link("https://blackhatmea.com/agenda-2024?combine=zkevm")[blackhatmea.com/agenda-2024]
    ]
  ),
  (
    title: "Stopping the New Wave of Mobile Banking Malware infecting users in South East Asia",
    subtitle: "VXCON",
    extra: "2024",
    description: [
      #link("https://vxcon.hk/")[vxcon.hk]
      |
      #link("https://youtu.be/bN6q7Efg0Wc?t=744")[youtu.be/bN6q7Efg0Wc]
    ]
  ),
  (
    title: "TSSHOCK: Breaking MPC Wallets and Digital Custodians for $BILLION$ Profit",
    subtitle: "Blackhat USA",
    extra: "2023",
    description: [
      #link("https://www.blackhat.com/us-23/briefings/schedule/#tsshock-breaking-mpc-wallets-and-digital-custodians-for-billion-profit-33343")[blackhat.com/us-23]
      |
      #link("https://youtu.be/5mlQb8PEF3A")[youtu.be/5mlQb8PEF3A]
    ]
  ),
  (
    title: "TSSHOCK: Breaking MPC Wallets and Digital Custodians for $BILLION$ Profit",
    subtitle: "Hack In The Box",
    extra: "2023",
    description: [
      #link("https://conference.hitb.org/hitbsecconf2023hkt/session/tsshock-breaking-mpc-wallets-and-digital-custodians/")[conference.hitb.org/hitbsecconf2023hkt]
      |
      #link("https://youtu.be/1ks2jcS7UE4")[youtu.be/1ks2jcS7UE4]
    ]
  ),
))


#cv-section("Awards and Honors")
#cv-list((
  (
    title: "Google Capture The Flag 2021",
    subtitle: "Team Ranking 19th"
  ),
  (
    title: "Google Capture The Flag 2020",
    subtitle: "Team Ranking 11th"
  ),
  (
    title: "International Olympiad in Cryptography 2020",
    subtitle: "Team Prize 2nd"
  ),
  (
    title: "ASEAN Student Contest on Information Security 2019",
    subtitle: "Team Finalist"
  ),
))

#v(5em)
#cv-section("Services")
#cv-list((
  (
    title: "Bachelor's thesis co-advisor",
    description: [
      My former advisor, #link("https://scholar.google.com/citations?user=ha11OwIAAAAJ&hl=vi")[Dr. Khuong Nguyen-An],
      invites me to be a co-advisor for his students’ bachelor’s thesis. \
      - Hoang Anh Hung, 2025 - 2026,
        #link("https://drive.google.com/file/d/1wjTBJ7sfL5zqm931K3eIA89rTQ6p3Sgz/view?usp=sharing")[AI Agent for binary patch diff: Localizing Exploitable Vulnerabilities in Closed-Source Binaries]
      - Nguyen Thien Nhan, 2024 - 2025,
        #link("https://drive.google.com/file/d/1n9GO2YHGaYsRGnViEJ2Bn22lZpF_s9fR/view?usp=sharing")[Emulate Smart Card with Proxmark 3]
      - Pham Nguyen Nam, 2024 - 2025,
        #link("https://drive.google.com/file/d/1e4qtoPm-FMnvUDUO09g1IDdjurpfIpJs/view?usp=sharing")[Static Binary Repairing with Code Insertion]
      - Do Dinh Phu Quy, 2023 - 2024,
        #link("https://drive.google.com/file/d/1Fm1YVAxD-A-zjVvRwBPa-IhZ1Y8ImEyv/view?usp=sharing")[Sandboxing Powershell scripts for ransomware detection]
      - Vo Van Tien Dung, 2022 - 2023,
        #link("https://drive.google.com/file/d/1X18tr4OvcNYRoyxzTcsxM_MgjcqVW1sk/view?usp=sharing")[Windows Memory Forensics: Detecting hidden injected code in a process]
    ]
  ),
  (
    title: "Efiens CTF Team Leader",
    extra: "2019 -- 2020",
    description: [
      Efiens is a highly advanced student group in reverse engineering, cryptography, pwning and web
      exploitation. See our competition achievement. Our members are Flare-on, Olympiad in Cryptography
      winners, and National cyber security competition winners.
    ]
  ),
))


// #cv-section("References")
// #cv-list((
//   (
//     title: "Professor Christos Dimoulas",
//     subtitle: "Northwestern University, IL, US",
//   ),
//   (
//     title: "Professor Xiao Wang",
//     subtitle: "Northwestern University, IL, US",
//   ),
//   (
//     title: "Professor Xinyu Xing",
//     subtitle: "Northwestern University, IL, US",
//   ),
//   (
//     title: "Khuong Nguyen-An, PhD",
//     subtitle: "University of Technology, VNU-HCM, Vietnam",
//   ),
//   (
//     title: "Anh Quynh Nguyen, PhD",
//     subtitle: "Nanyang Technological University, Singapore",
//   ),
// ))
