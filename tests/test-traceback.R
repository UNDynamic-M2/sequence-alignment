library(testthat)
source("../traceback.R")
source("../utilities.R")

test_that("test sequences are correctly assigned - horizontal then up", {
  # arrange
  seq1 = c("A", "B")
  seq2 = c("A", "B", "C", "D")
  sc_matrix = matrix(
    c(
      c(0, 0, 0, 0, 0),
      c(0, 3, 2, 3, 3),
      c(0, 1, 4, 5, 6)
    ),
    nrow = 3,
    ncol = 5,
    byrow = TRUE
  )
  expected_path = matrix(
    c(
      c(3, 3, 3, 2),
      c(5, 4, 3, 2)
    ),
    nrow = 2,
    ncol = 4,
    byrow = TRUE
  )

  # act
  result = traceback_funk(sc_matrix, seq1, seq2)
  alignment_results = result[[1]]
  alignment_result = alignment_results[[1]]
  alignment = alignment_result[[1]]
  path = alignment_result[[2]]
  dimnames(path) = NULL
  rownames(path) = NULL
  colnames(path) = NULL
  
  # assert
  expect_equal(path, expected_path)
})

test_that("test sequences are correctly assigned - diagonal and stop", {
  # arrange
  seq1 = c("A", "B")
  seq2 = c("A", "B", "C", "D")
  sc_matrix = matrix(
    c(
      c(0, 0, 0, 0, 0),
      c(0, 3, 2, 5, 3),
      c(0, 1, 4, 3, 6)
    ),
    nrow = 3,
    ncol = 5,
    byrow = TRUE
  )
  expected_path = matrix(
    c(
      c(3, 2),
      c(5, 4)
    ),
    nrow = 2,
    ncol = 2,
    byrow = TRUE
  )
  
  # act
  result = traceback_funk(sc_matrix, seq1, seq2)
  alignment_results = result[[1]]
  alignment_result = alignment_results[[1]]
  alignment = alignment_result[[1]]
  path = alignment_result[[2]]
  dimnames(path) = NULL
  rownames(path) = NULL
  colnames(path) = NULL
  
  # assert
  expect_equal(path, expected_path)
})

test_that("test sequences are correctly assigned - up and stop", {
  # arrange
  seq1 = c("A", "B")
  seq2 = c("A", "B", "C", "D")
  sc_matrix = matrix(
    c(
      c(0, 0, 0, 0, 0),
      c(0, 3, 2, 3, 5),
      c(0, 1, 4, 3, 6)
    ),
    nrow = 3,
    ncol = 5,
    byrow = TRUE
  )
  expected_path = matrix(
    c(
      c(3, 2),
      c(5, 5)
    ),
    nrow = 2,
    ncol = 2,
    byrow = TRUE
  )
  
  # act
  result = traceback_funk(sc_matrix, seq1, seq2)
  alignment_results = result[[1]]
  alignment_result = alignment_results[[1]]
  alignment = alignment_result[[1]]
  path = alignment_result[[2]]
  dimnames(path) = NULL
  rownames(path) = NULL
  colnames(path) = NULL
  
  # assert
  expect_equal(path, expected_path)
})

test_that("test sequences are correctly assigned - diagonal preference", {
  # arrange
  seq1 = c("A", "B")
  seq2 = c("A", "B", "C", "D")
  sc_matrix = matrix(
    c(
      c(0, 0, 0, 0, 0),
      c(0, 3, 2, 5, 5),
      c(0, 1, 4, 3, 6)
    ),
    nrow = 3,
    ncol = 5,
    byrow = TRUE
  )
  expected_path = matrix(
    c(
      c(3, 2),
      c(5, 4)
    ),
    nrow = 2,
    ncol = 2,
    byrow = TRUE
  )
  
  # act
  result = traceback_funk(sc_matrix, seq1, seq2)
  alignment_results = result[[1]]
  alignment_result = alignment_results[[1]]
  alignment = alignment_result[[1]]
  path = alignment_result[[2]]
  dimnames(path) = NULL
  rownames(path) = NULL
  colnames(path) = NULL
  
  # assert
  expect_equal(path, expected_path)
})