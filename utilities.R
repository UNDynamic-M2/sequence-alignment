console_log = function (message) {
  cat(c(message, "\n"))
}

print_matrix = function (mat) {
  for (i in mat) {
    console_log(i)
  }
}

print_program_header = function () {
  cat(c(
    " -------------------------------------\n",
    "| UNDynamic Sequence Alignment Tool |\n",
    "-------------------------------------"
  ))
}
