scoring_matrix = function (sequence1_char, sequence2_char, gap_open_penalty, gap_extend_penalty, subst_matrix) {
  sequence1 = as.list(strsplit(sequence1_char, "")[[1]])
  sequence2 = as.list(strsplit(sequence2_char, "")[[1]])
  rownames(subst_matrix) <- c("A","T","G","C")
  colnames(subst_matrix) <- c("A","T","G","C")
  
  rows = length(sequence1) + 1
  columns = length(sequence2) + 1
  S = matrix(0, rows, columns) # scoring matrix
  V = matrix(0, rows, columns)
  H = matrix(0, rows, columns)
  
  for (i in 2:rows) {
    for (j in 2:columns) {
      V[i,j] <- max(S[i-1,j]-gap_open_penalty,
                    V[i-1,j]-gap_extend_penalty)
      H[i,j] <- max(S[i,j-1]-gap_open_penalty,
                    H[i,j-1]-gap_extend_penalty)
      S[i,j] <- max(0, S[i-1,j-1] + subst_matrix[sequence1[[i-1]],sequence2[[j-1]]],
                    V[i,j],
                    H[i,j])
    }
  }
  
  return(S)
}