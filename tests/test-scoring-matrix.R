library(testthat)
source("../scoring-matrix.R")
source("../utilities.R")

test_that("test scoring matrix dimensions", {
  # arrange
  subst_matrix = get_default_substitution_matrix()
  
  # act
  sc_matrix = scoring_matrix(c("A", "A", "T"), c("A", "G", "T", "T"), 10, 0.5, subst_matrix)
  
  # assert
  expect_equal(nrow(sc_matrix), 4)
  expect_equal(ncol(sc_matrix), 5)
})

# TODO: add more tests
