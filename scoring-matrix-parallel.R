library(foreach)
library(doParallel)
library(parallel)

# TODO: still in progress

scoring_matrix_parallel = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix) {
  num_cores = detectCores()
  registerDoParallel(num_cores)
  
  m = length(sequence1) + 1
  n = length(sequence2) + 1
  max_d = m + n - 3
  
  S = matrix(0, m, n) # scoring matrix
  V = matrix(0, m, n)
  H = matrix(0, m, n)
  
  for (d in 1:max_d) {
    row_s = max(3, d - m)
    col_s = (d - row_s) + 3
    row_e = min(d, m)
    col_e = (d - row_e) + 3
    inds = cbind(row_s:row_e, col_s:col_e)
    
    # print(inds)
    
    V[inds] = foreach (p = 1:nrow(inds), .combine = c) %do% {
      i = inds[p, 1]
      j = inds[p, 2]
      
      if (i - 1 < 1) {
        V[i, j]
      } else {
        max(
          S[i - 1, j] - gap_open_penalty,
          V[i - 1, j] - gap_extend_penalty
        )
      }
    }
    
    H[inds] = foreach (p = 1:nrow(inds), .combine = c) %dopar% {
      i = inds[p, 1]
      j = inds[p, 2]
      
      if (j - 1 < 1) {
         H[i, j]
      } else {
        max(
          S[i, j - 1] - gap_open_penalty,
          H[i, j - 1] - gap_extend_penalty
        )
      }
    }
    
    S[inds] = foreach (p = 1:nrow(inds), .combine = c) %dopar% {
      i = inds[p, 1]
      j = inds[p, 2]
      
      if (i - 1 < 1 | j - 1 < 1) {
        S[i, j]
      } else {
        max(
          0,
          S[i - 1, j - 1] + subst_matrix[sequence1[i - 1], sequence2[j - 1]],
          V[i, j],
          H[i, j]
        )
      }
    }
  }
  
  rownames(S) = c('-', sequence1)
  colnames(S) = c('-', sequence2)
  
  return(S)
}

scoring_matrix_parallel_1 = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix) {
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

    VP[u, j] = unlist(mclapply(u, function (i) {
      max(
        SP[i - 1, j - 1] - gap_open_penalty,
        VP[i - 1, j - 1] - gap_extend_penalty
      )
    }, mc.cores = num_cores))

    HP[u, j] = unlist(mclapply(u, function (i) {
      max(
        SP[i, j - 1] - gap_open_penalty,
        HP[i, j - 1] - gap_extend_penalty
      )
    }, mc.cores = num_cores))

    SP[u, j] = unlist(mclapply(u, function (i) {
      max(
        0,
        SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
        VP[i, j],
        HP[i, j]
      )
    }, mc.cores = num_cores))
    
    # if (length(u) <= 1000) {
    #   for (i in u) {
    #     VP[i, j] = max(
    #       SP[i - 1, j - 1] - gap_open_penalty,
    #       VP[i - 1, j - 1] - gap_extend_penalty
    #     )
    # 
    #     HP[i, j] = max(
    #       SP[i, j - 1] - gap_open_penalty,
    #       HP[i, j - 1] - gap_extend_penalty
    #     )
    # 
    #     SP[i, j] = max(
    #       0,
    #       SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
    #       VP[i, j],
    #       HP[i, j]
    #     )
    #   }
    # } else {
    #   VP[u, j] = foreach (i = u, .combine = c) %dopar% {
    #     max(
    #       SP[i - 1, j - 1] - gap_open_penalty,
    #       VP[i - 1, j - 1] - gap_extend_penalty
    #     )
    #   }
    # 
    #   HP[u, j] = foreach (i = u, .combine = c) %dopar% {
    #     max(
    #       SP[i, j - 1] - gap_open_penalty,
    #       HP[i, j - 1] - gap_extend_penalty
    #     )
    #   }
    # 
    #   SP[u, j] = foreach (i = u, .combine = c) %dopar% {
    #     max(
    #       0,
    #       SP[i - 1, j - 2] + subst_matrix[sequence1[i - 1], sequence2[j - i]],
    #       VP[i, j],
    #       HP[i, j]
    #     )
    #   }
    # }
  
  }
  
  # TODO: parallelise this
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