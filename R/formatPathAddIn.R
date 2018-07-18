#' @title Format File Path
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
    # Get the document context.
    context <- rstudioapi::getActiveDocumentContext()
    # Set the default data to use based on the selection.
    text <- context$selection[[1]]$text
    defaultData <- text

    ui <- miniPage(
        gadgetTitleBar("Reformat File Path"),
        miniContentPanel(
            h4("New path"),
            uiOutput("fixed_path"),
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
        selected_text <- context[["selection"]][[1]][["text"]]
        selected_range <- context[["selection"]][[1]][["range"]]

        # Reactive document with formatted path
        reactiveDocument <- reactive({

            formatted_path <-
                deparse(
                    create_file_path_call(
                        path_string = selected_text,
                        mustWork = input$must_work,
                        normalize = input$normalize
                    )
                )
        })

        output$fixed_path <- renderText(reactiveDocument())

        # Paste text on done
        observeEvent(input$done, {
            # TODO: paste text withot escaping ""
            fixed_contents <- paste(reactiveDocument(), collapse = "\n")
            rstudioapi::modifyRange(location = selected_range, text = fixed_contents)
            invisible(stopApp())
        })

    }

    viewer <- dialogViewer("Reformat File Path",
                           width = 1000, height = 800)
    # TODO: avoid user cancel error
    runGadget(ui, server, viewer = viewer)

}
