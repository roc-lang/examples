app [main] { pf: platform "https://github.com/lukewilliamboswell/basic-ssg/releases/download/0.1.0/EMH2OFwcXCUEzbwP6gyfeRQu7Phr-slc-vE8FPPreys.tar.br" }

import pf.Task exposing [Task]
import pf.SSG
import pf.Types exposing [Args]
import pf.Html exposing [link, title, script, footer, div, text, p, html, head, body, meta]
import pf.Html.Attributes exposing [class, type, src, name, charset, href, rel, content, lang]

main : Args -> Task {} _
main = \{ inputDir, outputDir } ->

    # get the path and url of markdown files in content directory
    files = SSG.files! inputDir

    # helper Task to process each file
    processFile = \{ path, relpath, url } ->

        inHtml = SSG.parseMarkdown! path

        outHtml = transformFileContent url inHtml

        SSG.writeFile { outputDir, relpath, content: outHtml }
    ## process each file
    Task.forEach! files processFile

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
    Html.main [] [
        text htmlContent,
    ]

viewExample : Str -> Html.Node
viewExample = \htmlContent ->
    Html.main [] [
        text htmlContent,
    ]
