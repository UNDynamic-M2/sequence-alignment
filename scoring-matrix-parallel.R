library(foreach)
library(doParallel)
library(parallel)

scoring_matrix_parallel = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix) {
  rows = length(sequence1) + 1
  columns = length(sequence2) + 1
  S = matrix(0, rows, columns)
  V = matrix(0, rows, columns)
  H = matrix(0, rows, columns)
  
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
    VP[2:m, j] = foreach (i = 2:m, .combine = c) %dopar% {
      if (VP[i, j - 1] != -1 && VP[i, j] != -1) {
        max(
          SP[i - 1, j - 1] - gap_open_penalty,
          VP[i - 1, j - 1] - gap_extend_penalty
        )
      } else {
        VP[i, j]
      }
    }
    
    HP[2:m, j] = foreach (i = 2:m, .combine = c) %dopar% {
      if (HP[i, j - 1] != -1 && HP[i, j] != -1) {
        max(
          SP[i, j - 1] - gap_open_penalty,
          HP[i, j - 1] - gap_extend_penalty
        )
      } else {
        HP[i, j]
      }
    }

    SP[2:m, j] = foreach (i = 2:m, .combine = c) %dopar% {
      if (SP[i, j - 1] != -1 && SP[i, j] != -1) {
        max(
          0,
          SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
          VP[i, j],
          HP[i, j]
        )
      } else {
        SP[i, j]
      }
    }
  }
  
  # TODO: parallelise this
  for (i in 1:rows) {
    for (j in 1:columns) {
      S[i, j] = SP[i, j + i - 1]
    }
  }
  
  rownames(S) = c('-', sequence1)
  colnames(S) = c('-', sequence2)

  return(S)
}