#' @title Ffile.path("/")ormat File Path
#'
#' @description The functions provides an add-in interface on the
#'   \code{\link{create_file_path_call}} function.
#'
#' @details The add-in breaks the path string, example"
#'   \code{"~/stuff/projects/r/something/else"} into \code{\link[base]{file.path}}
#'   call. The function can optionally call \code{\link[base]{normalizePath}} on the
#'   passed string and modify default \code{fsep} argument of the
#'   \code{\link[base]{file.path}}.
#'
#' @references The add-in draws heavily on the code available in
#'   \url{https://github.com/rstudio/addinexamples}.
#'
#' @return Formatted file path using \code{\link[base]{file.path}}.
#'
#' @export
#'
formatPathAddIn <- function() {

    ui <- miniPage(
        gadgetTitleBar(
            title = "Reformat File Path",
            right = miniTitleBarButton(
                inputId = "done",
                label = "Paste",
                primary = TRUE
            )
        ),
        miniContentPanel(
            h4("New path"),
            verbatimTextOutput("fixed_path"),
            checkboxInput(
                inputId = "here",
                label = "use here",
                value = FALSE
            ),
            checkboxInput(
                inputId = "normalize",
                label = "Normalize",
                value = FALSE
            ),
            conditionalPanel(
                condition = "input.normalize == 1",
                checkboxInput(
                    inputId = "must_work",
                    label = "Must work",
                    value = FALSE
                )
            )
        )
    )

    server <- function(input, output, session) {
        # Get the document context.
        context <- rstudioapi::getActiveDocumentContext()
        selected_text <- gsub(pattern = '"',
                              replacement = '',
                              x = context[["selection"]][[1]][["text"]])
        # if nothing is selected, warns the user and exit
        if (!nzchar(selected_text)) {
            rstudioapi::showDialog("Error",
                                   "text selection is empty")
            invisible(stopApp())
        }
        selected_range <- context[["selection"]][[1]][["range"]]

        observe({
            if (!requireNamespace("here", quietly = TRUE) && input$here) {
                rstudioapi::showDialog("Error",
                                       "here is not installed",
                                       "https://github.com/r-lib/here")
                shiny::updateCheckboxInput(session, inputId = "here", value = FALSE)
            }
        })
        # Reactive document with formatted path
        reactiveDocument <- reactive({
            formatted_path <-
                deparse(
                    create_file_path_call(
                        path_string = selected_text,
                        mustWork = input$must_work,
                        normalize = input$normalize,
                        here = input$here
                    )
                )
        })

        output$fixed_path <- renderText(reactiveDocument())

        # Paste text on done
        observeEvent(input$done, {
            fixed_contents <-
                paste(reactiveDocument(), collapse = "\n")
            rstudioapi::modifyRange(location = selected_range, text = fixed_contents)
            invisible(stopApp())
        })

    }

    viewer <- dialogViewer("Reformat File Path",
                           width = 600, height = 200)
    runGadget(ui, server, viewer = viewer)

}
