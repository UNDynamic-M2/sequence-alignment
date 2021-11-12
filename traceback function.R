# functionalise
traceback_funk <- function(scoring_matrix, seq_1, seq_2) {
  
  # find maximum value in scoring matrix and allocate as score and start position
  score <- max(scoring_matrix)
  start_position <- which(scoring_matrix == score, arr.ind = TRUE)
  
  # create alignment list to record all possible alignments
  alignment_list <- list()
  
  # for loop over all possible start positions
  for(i in 1:nrow(start_position)) {
    
    position <- start_position[i,]
    
    # create alignment variables
    alignment_vector <- c(seq_1[position[1]-1],seq_2[position[2]-1])
    alignment_matrix <- matrix(alignment_vector)
    
    #while (scoring_matrix[position] != 0) {
    for (n in 1:(length(seq_1)+1)) { # need to figure out how to loop over length
      
      # Create step vector of next possible steps, the maximum of which will be the next postion of the traceback loop
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
        alignment_matrix <- cbind(alignment_matrix, c('_',seq_2[position[2]-1]))
      } else {
        jump <- c(-1,0)
        position <- position + jump
        # the next base from seq_1 is added to the top row but a space corresponding with seq_2 is added to the bottom
        alignment_matrix <- cbind(alignment_matrix, c(seq_1[position[1]-1],'_'))
      }
    }
    
    alignment_list[[i]] <- alignment_matrix
  }
  return(alignment_list)
}