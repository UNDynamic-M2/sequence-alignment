library(testthat)
source("../scoring-matrix.R")
source("../utilities.R")

test_that("test scoring matrix dimensions", {
  # arrange
  subst_matrix = get_default_substitution_matrix()
  seq1 = c("A", "A", "T")
  seq2 = c("A", "G", "T", "T")
  gap_open_penalty = 10
  gap_extend_penalty = 0.5
  
  # act
  sc_matrix = scoring_matrix(seq1, seq2, gap_open_penalty, gap_extend_penalty, subst_matrix)
  
  # assert
  expect_equal(nrow(sc_matrix), 4)
  expect_equal(ncol(sc_matrix), 5)
})

test_that("test max score", {
  # arrange
})
