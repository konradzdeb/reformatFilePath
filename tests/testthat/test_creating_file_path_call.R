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
