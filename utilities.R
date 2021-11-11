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

is_sequence_correct = function (seq) {
  seq_vector = unlist(strsplit(seq, split = ""))
  bases = c("A", "T", "G", "C")
  
  for (base in seq_vector) {
    if (!(base %in% bases)) {
      return(FALSE)
    }
  }
  
  return(TRUE)
}
