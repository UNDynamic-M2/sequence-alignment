# ===========================================================
# scoring-matrix-parallel.R
# 
# Given two sequences, gap penalties and substitution matrix,
# it will return the Smith-Waterman scoring matrix.
#
# Authors:
# - Ossama Edbali
# ===========================================================

library(foreach)
library(doParallel)
library(parallel)

scoring_matrix_parallel = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix) {
  rows = length(sequence1) + 1
  columns = length(sequence2) + 1

  m = rows
  n = rows + columns - 1
  
  SP = matrix(-1, m, n)
  VP = matrix(-1, m, n)
  HP = matrix(-1, m, n)
  
  num_cores = detectCores()
  registerDoParallel(num_cores)
  
  for (i in 1:rows) {
    for (j in 1:columns) {
      SP[i, j + i - 1] = 0
      VP[i, j + i - 1] = 0
      HP[i, j + i - 1] = 0
    }
  }
  
  for (j in 3:n) {
    u = which(VP[,j] != -1 & VP[,j-1] != -1)
    u = u[u != 1]
    
    if (length(u) <= 1000) {
      for (i in u) {
        VP[i, j] = max(
          SP[i - 1, j - 1] - gap_open_penalty,
          VP[i - 1, j - 1] - gap_extend_penalty
        )

        HP[i, j] = max(
          SP[i, j - 1] - gap_open_penalty,
          HP[i, j - 1] - gap_extend_penalty
        )

        SP[i, j] = max(
          0,
          SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
          VP[i, j],
          HP[i, j]
        )
      }
    } else {
      VP[u, j] = foreach (i = u, .combine = c) %dopar% {
        max(
          SP[i - 1, j - 1] - gap_open_penalty,
          VP[i - 1, j - 1] - gap_extend_penalty
        )
      }

      HP[u, j] = foreach (i = u, .combine = c) %dopar% {
        max(
          SP[i, j - 1] - gap_open_penalty,
          HP[i, j - 1] - gap_extend_penalty
        )
      }

      SP[u, j] = foreach (i = u, .combine = c) %dopar% {
        max(
          0,
          SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
          VP[i, j],
          HP[i, j]
        )
      }
    }
  }
  
  S = matrix(0, rows, columns)

  for (i in 1:rows) {
    for (j in 1:columns) {
      S[i, j] = SP[i, j + i - 1]
    }
  }
  
  rownames(S) = c('-', sequence1)
  colnames(S) = c('-', sequence2)

  return(S)
}