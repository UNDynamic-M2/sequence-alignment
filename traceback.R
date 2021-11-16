# functionalise
traceback_funk <- function(scoring_matrix, seq_1, seq_2) {
  
  # find maximum value in scoring matrix and allocate as score and start position
  score <- max(scoring_matrix)
  start_positions <- which(scoring_matrix == score, arr.ind = TRUE)
  
  # create alignment list to record all possible alignments
  alignment_list <- list()
  
  # for loop over all possible start positions
  for(i in 1:nrow(start_positions)) {
    
    position <- start_positions[i,]
    start_position <- position
    end_position <- position
    
    pathway <- matrix(position, nrow = 2, ncol = 1)
    
    # a matrix is created for the alignment and filled with the initial alignment, with the top row corresponding to seq_1 and the bottom seq_2
    initial_alignment <- c(seq_1[position[1]-1],seq_2[position[2]-1])
    alignment_matrix <- matrix(initial_alignment)
    
    diagonal_pos <- c(start_position[1] - 1, start_position[2] - 1) 
    
    # for loop over the alignment pairs
    for (n in 1:(length(seq_1)+1)) {
      if (diagonal_pos[1] == 1 | diagonal_pos[2] == 1) {
        break
      }
      
      # Create step vector of next possible steps, the maximum of which will be the next position of the traceback loop
      step_vec <- rep(0,3)
      
      vertical <- scoring_matrix[position[1] -1, position[2]]
      horizontal <- scoring_matrix[position[1], position[2] -1]
      diagonal <- scoring_matrix[position[1] -1, position[2] -1]
      
      step_vec <- step_vec + c(vertical, horizontal, diagonal)
      
      if (max(step_vec) == diagonal) {
        # if the diagonal is equal to the maximum value in the step_vec, position moves up and left
        jump <- c(-1,-1)
        position <- position + jump
        # a vector is added to the alignment matrix that contains values from both sequences
        alignment_matrix <- cbind(alignment_matrix, c(seq_1[position[1]-1],seq_2[position[2]-1]))
      } else if (max(step_vec) == horizontal) {
        jump <- c(0,-1)
        position <- position + jump
        # the next base from seq_2 is added to the bottom row but a space corresponding with seq_1 is added to the top
        alignment_matrix <- cbind(alignment_matrix, c('-',seq_2[position[2]-1]))
      } else {
        jump <- c(-1,0)
        position <- position + jump
        # the next base from seq_1 is added to the top row but a space corresponding with seq_2 is added to the bottom
        alignment_matrix <- cbind(alignment_matrix, c(seq_1[position[1]-1],'-'))
      }
      
      pathway <- append(pathway,position)
      
      # set up diagonal position so that if the position enters row 1 or column 1, end the for loop
      diagonal_pos <- position + c(-1, -1)
      
      end_position <- position
    }
    
    # reverse sequences so lign up with original input
    rev_seq1 <- rev(alignment_matrix[1,])
    rev_seq2 <- rev(alignment_matrix[2,])
    alignment_matrix[1,] <- rev_seq1
    alignment_matrix[2,] <- rev_seq2
    
    alignment_list[[i]] <- list(alignment_matrix, pathway)
    #alignment_list[[i]] <- list(alignment_matrix, start_position, end_position)
  }
  
  return(list(alignment_list,score))
}