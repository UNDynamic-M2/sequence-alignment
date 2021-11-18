source("utilities.R")
source("scoring-matrix.R")
source("traceback.R")
source("pretty-printing.R")

deps = readLines("dependencies.txt")
install.packages(deps)

main = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix) {
  sequence1_vector = unlist(strsplit(sequence1, split = ""))
  sequence2_vector = unlist(strsplit(sequence2, split = ""))
  
  sc_matrix = scoring_matrix(sequence1_vector, sequence2_vector, gap_open_penalty, gap_extend_penalty, subst_matrix)
  print(sc_matrix)
  
  traceback_result = traceback_funk(sc_matrix, sequence1_vector, sequence2_vector)
  alignment_results = traceback_result[[1]]
  score = traceback_result[[2]]
  
  for (i in 1:length(alignment_results)) {
    console_log("\nFound alignment:")

    alignment_result = alignment_results[[i]]
    alignment = alignment_result[[1]]
    path = alignment_result[[2]]
    start_position = path[,1]
    end_position = path[,ncol(path)]
    
    alignment_pretty_printed = pretty_print(
      sequence1_vector,
      sequence2_vector,
      alignment[1,],
      alignment[2,],
      start_position,
      end_position
    )
    
    console_log(paste(alignment_pretty_printed, collapse = "\n"))
    console_log("Traceback path:")
    print(path)
  }
}

# Inputs
sequence1 = "GATTACA"
sequence2 = "ATTACATTAC"
gap_open_penalty = 12
gap_extend_penalty = 3
subst_matrix = get_default_substitution_matrix()

main(sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix)
