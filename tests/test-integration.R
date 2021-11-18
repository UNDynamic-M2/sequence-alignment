library(testthat)
source("../scoring-matrix.R")
source("../traceback.R")
source("../utilities.R")

test_that("sequence1: AATG, sequence2: AACA", {
  # arrange
  seq1 = c("A", "A", "T", "G")
  seq2 = c("A", "A", "C", "A")
  gap_open_penalty = 12
  gap_extend_penalty = 3
  subst_matrix = get_default_substitution_matrix()
  
  # act
  sc_matrix = scoring_matrix(seq1, seq2, gap_open_penalty, gap_extend_penalty, subst_matrix)
  result = traceback_funk(sc_matrix, seq1, seq2)
  
  alignment_results = result[[1]]
  score = result[[2]]
  alignment_result = alignment_results[[1]]
  
  alignment = alignment_result[[1]]
  dimnames(alignment) = NULL
  rownames(alignment) = NULL
  colnames(alignment) = NULL
  
  path = alignment_result[[2]]
  dimnames(path) = NULL
  rownames(path) = NULL
  colnames(path) = NULL
  
  # assert
  expected_alignment = matrix(
    c(
      c("A", "A"),
      c("A", "A")
    ),
    nrow = 2,
    ncol = 2
  )
  
  expected_path = matrix(
    c(
      c(3, 2),
      c(3, 2)
    ),
    nrow = 2,
    ncol = 2,
    byrow = TRUE
  )
  
  expect_equal(score, 10)
  expect_equal(length(alignment_results), 1)
  expect_equal(alignment, expected_alignment)
  expect_equal(path, expected_path)
})
