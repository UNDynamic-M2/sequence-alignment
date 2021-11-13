pad_start = function (seq, pad_length) {
  space_addition = pad_length - length(seq)
  space_vector = rep(' ', space_addition)
  seq = append(space_vector, seq)
  
  return(seq)
}

pad_end = function (seq, pad_length) {
  space_addition = pad_length - length(seq)
  space_vector = rep(' ', space_addition)
  seq = append(seq, space_vector)
  
  return(seq)
}

pretty_print = function(seq1, seq2, aligned_seq1, aligned_seq2, start_position, end_position) {
  alignment_str = c()
  
  for(i in 1:length(aligned_seq1)) {
    base1 = aligned_seq1[i]
    base2 = aligned_seq2[i]
    
    if (base1 == base2){
      alignment_str = append(alignment_str, '|')
    } else if (base1 == '-' | base2 == '-'){
      alignment_str = append(alignment_str, ' ')
    } else {
      alignment_str = append(alignment_str, ':')
    }
  }
  
  if (end_position[1] - 1 <= 1) {
    pre_alignment_seq1 = c()
  } else {
    pre_alignment_seq1 = seq1[1:(end_position[1] - 2)]
  }

  if (end_position[2] - 1 <= 1) {
    pre_alignment_seq2 = c()
  } else {
    pre_alignment_seq2 = seq2[1:(end_position[2] - 2)]
  }
  
  addition_vec = c(length(pre_alignment_seq1),length(pre_alignment_seq2))
  max_pre = max(addition_vec)
  
  pre_alignment_seq1 = pad_start(pre_alignment_seq1, max_pre)
  pre_alignment_seq2 = pad_start(pre_alignment_seq2, max_pre)
  
  if (start_position[1] - 1 == length(seq1)) {
    post_alignment_seq1 = c()
  } else {
    post_alignment_seq1 = seq1[start_position[1]:length(seq1)]
  }
  
  if (start_position[2] - 1 == length(seq2)) {
    post_alignment_seq2 = c()
  } else {
    post_alignment_seq2 = seq2[start_position[2]:length(seq2)]
  }
  
  addition_vec = c(length(post_alignment_seq1), length(post_alignment_seq2))
  max_post = max(addition_vec)
  
  post_alignment_seq1 = pad_end(post_alignment_seq1, max_post)
  post_alignment_seq2 = pad_end(post_alignment_seq2, max_post)
  
  alignment_str = append(rep(' ', max_pre), alignment_str)
  
  aligned_seq1 = append(pre_alignment_seq1, c(aligned_seq1, post_alignment_seq1))
  aligned_seq2 = append(pre_alignment_seq2, c(aligned_seq2, post_alignment_seq2))
  
  
  
  
  aligned_seq1_str = paste(aligned_seq1, collapse = '')
  aligned_seq2_str = paste(aligned_seq2, collapse = '')
  align_str = paste(alignment_str, collapse = '')
  
  return(paste(aligned_seq1_str, align_str, aligned_seq2_str, sep = '\n'))
}
