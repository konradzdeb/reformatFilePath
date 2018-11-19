context("Test creating file path call")

# Check that returned object is of class call
test_that(desc = "Returned object is a function",
          code = expect_is(object = create_file_path_call(tempdir()),
                           class = "call"))

# Check that returned call would evaluate to a string
if (requireNamespace("checkmate", quietly = TRUE)) {
    test_that(desc = "The function returns string",
              code = checkmate::expect_string(eval(create_file_path_call(tempdir(
              )))))
}

test_that("returned strings", {
    sep <- .Platform$file.sep
    path <- paste0("test", sep, "this")
    expect_equal(deparse(create_file_path_call(path)),
                 "normalizePath(file.path(\"/\", \"test\", \"this\"), mustWork = TRUE)")
    expect_equal(deparse(create_file_path_call(path, normalize = FALSE)),
                 "file.path(\"/\", \"test\", \"this\")")
    expect_equal(deparse(create_file_path_call(path, mustWork = FALSE)),
                 "normalizePath(file.path(\"/\", \"test\", \"this\"))")
    if (requireNamespace("here", quietly = TRUE)) {
        expect_equal(deparse(create_file_path_call(path, here = TRUE, normalize = FALSE)),
                     "here(\"/\", \"test\", \"this\")")
    }
})

test_that("useable path", {
    dcf <- system.file("rstudio", "addins.dcf",
                       package = "reformatFilePath", mustWork = TRUE)
    content <- readLines(eval(create_file_path_call(dcf)))
    expect_equal(content, c("Name: Format File Path",
                            "Description: Format file path using 'file.path()'",
                            "Binding: formatPathAddIn", "Interactive: true"))
})
