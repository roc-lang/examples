app "generate-build"
    packages { pf: "/home/runner/work/examples/examples/roc_nightly/examples/static-site-gen" }
    imports [
        pf.Html.{ html, svg, main, p, footer, h1, script, head, header, body, div, text, a, link, meta, title },
        pf.Html.Attributes.{ role, attribute, name, src, content, href, rel, lang, class, charset, type },
    ]
    provides [transformFileContent] to pf

transformFileContent : Str, Str -> Str
transformFileContent = \fileName, htmlContent -> Html.render (view fileName htmlContent)

view : Str, Str -> Html.Node
view = \fileName, htmlContent ->
    viewContent =
        when fileName is
            "index.html" -> viewIndex htmlContent
            _ -> viewExample htmlContent

    html [lang "en"] [
        head [] [
            title [] [text "Roc Examples"],
            meta [charset "utf-8"] [],
            meta [name "viewport", content "width=device-width"] [],
            link [rel "icon", href "/favicon.svg"] [],
            link [rel "stylesheet", href "/styles.css"] [],
            script [type "text/javascript", src "/copy-btn.js", defer ""] []
        ],
        body [] [
            div [class "top-header-extension"] [],
            header [class "top-header"] [
                div [class "pkg-and-logo"] [
                    a [class "logo", href "/"] [logoSvg],
                    h1 [class "pkg-full-name"] [
                        a [href "/index.html"] [text "Examples"],
                    ],
                ],
                div [class "top-header-triangle"] [],
            ],
            p [class "feedback"] [
                text "we 💜 feedback: ",
                a [href "https://github.com/roc-lang/examples"] [text "GitHub"],
                text " | ",
                a [href "https://roc.zulipchat.com/"] [text "Group Chat"],
            ],
            viewContent,
            footer [] [
                p [] [text "Made by people who like to make nice things © 2023"],
            ],
        ],
    ]

viewIndex : Str -> Html.Node
viewIndex = \htmlContent ->
    main [] [
        text htmlContent,
    ]

viewExample : Str -> Html.Node
viewExample = \htmlContent ->
    main [] [
        text htmlContent,
    ]

logoSvg =
    svg
        [
            viewBox "0 -6 51 58",
            fill "none",
            xmlns "http://www.w3.org/2000/svg",
            ariaLabelledBy "logo-link",
            role "img",
        ]
        [
            Html.title [id "logo-link"] [text "Return to Roc packages"],
            polygon
                [
                    role "presentation",
                    points "0,0 23.8834,3.21052 37.2438,19.0101 45.9665,16.6324 50.5,22 45,22 44.0315,26.3689 26.4673,39.3424 27.4527,45.2132 17.655,53 23.6751,22.7086",
                ]
                [],
        ]

ariaLabelledBy = attribute "aria-labelledby"
xmlns = attribute "xmlns"
fill = attribute "fill"
viewBox = attribute "viewBox"
id = attribute "id"
points = attribute "points"
defer = attribute "defer"
polygon = Html.element "polygon"
