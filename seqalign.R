#!/usr/bin/env Rscript

#
# seqalign
#

library("optparse")
source("utilities.R")

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
options = parse_args(opt_parser, positional_arguments = TRUE)

if (length(options$args) != 2) {
  console_log("Please provide both sequences.")
  quit(status = 1)
}

sequence1 = options$args[0]
sequence2 = options$args[1]
subst_matrix = NULL
gap_open_penalty = options$gap_open_penalty
gap_extend_penalty = options$gap_extend_penalty

if (is.null(options$subst_matrix)) {
  subst_matrix = matrix(c(
   c(5, -4, -4, -4),
   c(-4, 5, -4, -4),
   c(-4, -4, 5, -4),
   c(-4, -4, -4, 5)), 4, 4)
}

print_program_header()
console_log("\nRunning sequence alignment with:")
console_log(c("Sequence 1: ", sequence1))
console_log(c("Sequence 2: ", sequence2))
console_log(subst_matrix)
