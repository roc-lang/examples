app "generate-build"
    packages { pf: "/home/runner/work/examples/examples/roc_nightly/examples/static-site-gen/platform/main.roc" }
    imports [
        pf.Html.{ html, main, p, footer, script, head, body, div, text, link, meta, title },
        pf.Html.Attributes.{ name, src, content, href, rel, lang, class, charset, type },
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
            meta [charset "utf-8"],
            meta [name "viewport", content "width=device-width"],
            link [rel "icon", href "/favicon.svg"],
            link [rel "stylesheet", href "/site.css"],
            script [type "text/javascript", src "/site.js"] [],
        ],
        body [] [
            div [class "top-header-extension"] [],
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
