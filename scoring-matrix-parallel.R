scoring_matrix_parallel = function (sequence1, sequence2, gap_open_penalty, gap_extend_penalty) {
  rows = length(sequence1) + 1
  columns = length(sequence2) + 1
  S = matrix(1, rows, columns)
  V = matrix(0, rows, columns)
  H = matrix(0, rows, columns)
  
  S[1,] = 0
  S[,1] = 0
  
  vd = split(V, row(V) + col(V))
  
  hd = split(H, row(H) + col(H))
  
  sd = split(S, row(S) + col(S))
  
  
  
  for (i in 3:length(sd)) {
    # parallelise
    vd_vec = vd[i]
    for (j in 2:(length(vd_vec) - 1)) {
      vd_vec[j] = max(
        vd[i - 1][j - 1] - gap_extend_penalty,
        sd[i - 1][j - 1] - gap_open_penalty
      )
    }

    hd_vec = hd[i]
    for (j in 2:(length(hd_vec) - 1)) {
      hd_vec[j] = max(
        hd[i - 1][j] - gap_extend_penalty,
        sd[i - 1][j] - gap_open_penalty
      )
    }

  }
  
  return(sd)
}