#!/usr/bin/env Rscript

#
# seqalign
#

library("optparse")
source("utilities.R")
source("scoring-matrix.R")

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

if (length(arguments) != 2) {
  console_log("Please provide both sequences.")
  quit(status = 1)
}

sequence1 = arguments[1]
sequence2 = arguments[2]
subst_matrix = NULL
gap_open_penalty = options$gap_open_penalty
gap_extend_penalty = options$gap_extend_penalty

if (is.null(options$subst_matrix)) {
  subst_matrix = matrix(c(
   c(5, -4, -4, -4),
   c(-4, 5, -4, -4),
   c(-4, -4, 5, -4),
   c(-4, -4, -4, 5)), 4, 4)
} else {
  subst_matrix = read.table(options$subst_matrix, sep = " ")
}

print_program_header()
console_log("\nRunning sequence alignment with:")
console_log(c("Sequence 1: ", sequence1))
console_log(c("Sequence 2: ", sequence2))
console_log("Substitution matrix:")
print(subst_matrix)
console_log(c("Gap opening penalty: ", gap_open_penalty))
console_log(c("Gap extending penalty: ", gap_extend_penalty))

# Call initialise and fill of scoring matrix
sc_matrix = scoring_matrix(sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix)
print(sc_matrix)

# Call tracebacking

# Call pretty printing

