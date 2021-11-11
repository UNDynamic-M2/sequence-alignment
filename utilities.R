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
    "-------------------------------------",
    "| UNDynamic Sequence Alignment Tool |",
    "-------------------------------------"
  ), sep="\n")
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

get_default_substitution_matrix = function () {
  subst_matrix = matrix(c(
    c(5, -4, -4, -4),
    c(-4, 5, -4, -4),
    c(-4, -4, 5, -4),
    c(-4, -4, -4, 5)), 4, 4)
  
  return(subst_matrix)
}
