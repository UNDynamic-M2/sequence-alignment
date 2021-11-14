#!/usr/bin/env Rscript

# ===============================================
# seqalign
#
# Usage: seqalign.R [options]
#
# Options:
#  -s FILENAME, --subst_matrix=FILENAME
#  filename with the substitution matrix
#  
#  -p FLOAT, --gap_open_penalty=FLOAT
#  the gap opening penalty
#  
#  -e FLOAT, --gap_extend_penalty=FLOAT
#  the gap extension penalty
#  
#  -h, --help
#  Show this help message and exit
#
# 
# Authors:
# - Daniel Power
# - Haonan Jiang
# - Haonan Wang
# - Hussain Asif
# - Ossama Edbali
# - Waleed Hussain
# ===============================================

library(optparse)
source("utilities.R")
source("scoring-matrix.R")
source("traceback.R")
source("pretty-printing.R")

# --------------------------------------------
# Define the options that the program can take
# --------------------------------------------

option_list = list(
  make_option(
    c("-s", "--subst_matrix"),
    type="character",
    default=NULL, 
    help="filename with the substitution matrix",
    metavar="filename"
  ),
  make_option(
    c("-p", "--gap_open_penalty"),
    type="double",
    default=10, 
    help="the gap opening penalty",
    metavar="float"
  ),
  make_option(
    c("-e", "--gap_extend_penalty"),
    type="double",
    default=0.5, 
    help="the gap extension penalty",
    metavar="float"
  )
) 

opt_parser = OptionParser(option_list=option_list)
parsed_cmd = parse_args(opt_parser, positional_arguments = TRUE)
options = parsed_cmd$options
arguments = parsed_cmd$args

# ----------------------
# Validate the arguments
# ----------------------

if (length(arguments) != 2) {
  console_log("Please provide both sequences.")
  quit(status = 1)
}

sequence1 = arguments[1]
sequence2 = arguments[2]

if (file.exists(sequence1)) {
  sequence1 = paste(readLines(sequence1), collapse="")
}

if (file.exists(sequence2)) {
  sequence2 = paste(readLines(sequence2), collapse="")
}

sequence1 = toupper(sequence1)
sequence2 = toupper(sequence2)

# Check correctness of sequences
# ------------------------------

if (!is_sequence_correct(sequence1)) {
  console_log("Sequence 1 is not in the correct format.")
  quit(status = 1)
}

if (!is_sequence_correct(sequence2)) {
  console_log("Sequence 2 is not in the correct format.")
  quit(status = 1)
}

sequence1_vector = unlist(strsplit(sequence1, split = ""))
sequence2_vector = unlist(strsplit(sequence2, split = ""))
short_sequences = length(sequence1_vector) < 50 && length(sequence2_vector) < 50

# Check correctness of gap penalties
# ----------------------------------

gap_open_penalty = options$gap_open_penalty
gap_extend_penalty = options$gap_extend_penalty

if (gap_open_penalty <= gap_extend_penalty) {
  console_log("Warning: gap open penalty is less than the extension penalty!")
}

# Check correctness of substitution matrix
# ----------------------------------------

subst_matrix = NULL

if (is.null(options$subst_matrix)) {
  subst_matrix = get_default_substitution_matrix()
} else {
  subst_matrix = read.table(
    options$subst_matrix,
    sep = " ",
    row.names = c("A", "T", "G", "C"),
    col.names = c("A", "T", "G", "C")
  )
}

rownames(subst_matrix) = c("A","T","G","C")
colnames(subst_matrix) = c("A","T","G","C")

# ---------------
# Run the program
# ---------------

# Display input information
# -------------------------

print_program_header()
console_log("\nRunning sequence alignment with:")

if (short_sequences) {
  console_log(c("Sequence 1: ", sequence1))
  console_log(c("Sequence 2: ", sequence2))
} else {
  console_log("Input sequences are too big to display.")
}

console_log("Substitution matrix:")
print(subst_matrix)

console_log(c("Gap opening penalty: ", gap_open_penalty))
console_log(c("Gap extending penalty: ", gap_extend_penalty))

console_log("\nRunning Smith-Waterman algorithm for local sequence alignment...\n")

# Call initialise and fill of scoring matrix
# ------------------------------------------

console_log("1) Initialising and filling the scoring matrix")
sc_matrix = scoring_matrix(sequence1_vector, sequence2_vector, gap_open_penalty, gap_extend_penalty, subst_matrix)

write.table(sc_matrix, file="scoring_matrix.txt")
console_log("Scoring matrix saved in 'scoring_matrix.txt'")

if (short_sequences) {
  print(sc_matrix)
}

# Call tracebacking
# -----------------

console_log("\n2) Tracebacking")
alignment_results = traceback_funk(sc_matrix, sequence1_vector, sequence2_vector)

for (i in 1:length(alignment_results)) {
  console_log(c("\nOptimal alignment:", i))

  alignment_result = alignment_results[[i]]
  alignment = alignment_result[[1]]
  start_position = alignment_result[[2]]
  end_position = alignment_result[[3]]

  console_log(paste(alignment[1,], collapse = ""))
  console_log(paste(alignment[2,], collapse = ""))
  console_log(c("\nStart position:", start_position[1], ",", start_position[2]))
  console_log(c("End position:", end_position[1], ",", end_position[2]))
  console_log(c("Score:", sc_matrix[start_position[1], start_position[2]]))
}

# Call pretty printing
# --------------------

console_log("\n3) Conventional printing")
alignment_result = alignment_results[[1]]
alignment = alignment_result[[1]]
start_position = alignment_result[[2]]
end_position = alignment_result[[3]]
alignment_pretty_printed = pretty_print(
  sequence1_vector,
  sequence2_vector,
  alignment[1,],
  alignment[2,],
  start_position,
  end_position
)
console_log(alignment_pretty_printed)
