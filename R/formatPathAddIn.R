#' @title Format File Path
#'
#' @description The add-in formats string file path into a call using \code{file.path}
#'   function.
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
        gadgetTitleBar("Reformat Code"),
        miniContentPanel(
            stableColumnLayout(
                checkboxInput("brace.newline", "Place left braces '{' on a new line?", FALSE),
                numericInput("indent", "Indent size: ", 2),
                numericInput("width", "Column width: ", 60)
            ),
            uiOutput("document", container = rCodeContainer)
        )
    )

}
