# ===========================================================
# utilities.R
# 
# Contains utility functions that are not particularly
# central to the algorithm.
# ===========================================================

# Prints a message with a new line 
# message: the message to print
console_log = function (message) {
  cat(c(message, "\n"))
}

# Prints the program header
print_program_header = function () {
  cat(c(
    "===========================================",
    "|                                         |",
    "| UNDynamic Local Sequence Alignment Tool |",
    "|                                         |",
    "==========================================="
  ), sep="\n")
}

# Prints the traceback path
# tpath: the traceback path as a matrix where the 1st row contains
#        rows in the scoring matrix and the 2nd row contains the columns
print_traceback_path = function (tpath) {
  pathway_vec = c()
  
  for (z in 1:ncol(tpath)) {
    pathway_vec = append(pathway_vec, paste(tpath[,z], collapse = ","))      
  }
  
  console_log(paste(pathway_vec, collapse = " -> "))
}

# Checks if the sequence only contains the bases
# seq: the sequence to check
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

# Returns the default substitution matrix (DNAFull)
get_default_substitution_matrix = function () {
  subst_matrix = matrix(c(
    c(5, -4, -4, -4),
    c(-4, 5, -4, -4),
    c(-4, -4, 5, -4),
    c(-4, -4, -4, 5)), 4, 4)
  
  rownames(subst_matrix) = c("A","T","G","C")
  colnames(subst_matrix) = c("A","T","G","C")
  
  return(subst_matrix)
}

# Pads the start of a sequence (vector) with spaces according to the pad length
# seq: the sequence vector
# pad_length
pad_start = function (seq, pad_length) {
  space_addition = pad_length - length(seq)
  space_vector = rep(' ', space_addition)
  seq = append(space_vector, seq)
  
  return(seq)
}

# Pads the end of a sequence (vector) with spaces according to the pad length
# seq: the sequence vector
# pad_length
pad_end = function (seq, pad_length) {
  space_addition = pad_length - length(seq)
  space_vector = rep(' ', space_addition)
  seq = append(seq, space_vector)
  
  return(seq)
}
