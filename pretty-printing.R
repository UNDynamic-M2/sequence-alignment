source("utilities.R")

get_pre_alignment_vector = function (seq, limit_index) {
  if (limit_index <= 1) {
    pre_alignment_vector = c()
  } else {
    pre_alignment_vector = seq[1:(limit_index - 1)]
  }
  
  return(pre_alignment_vector)
}

get_post_alignment_vector = function (seq, limit_index) {
  last_index = length(seq)

  if (limit_index == last_index) {
    post_alignment_vector = c()
  } else {
    post_alignment_vector = seq[(limit_index + 1):last_index]
  }
  
  return(post_alignment_vector)
}

get_alignment_indicators = function (aligned_seq1, aligned_seq2) {
  alignment_indicators = c()
  
  for(i in 1:length(aligned_seq1)) {
    base1 = aligned_seq1[i]
    base2 = aligned_seq2[i]
    
    if (base1 == base2){
      alignment_indicators = append(alignment_indicators, '|')
    } else if (base1 == '-' | base2 == '-'){
      alignment_indicators = append(alignment_indicators, ' ')
    } else if (base1 != ' ' && base2 != ' ') {
      alignment_indicators = append(alignment_indicators, ':')
    } else {
      alignment_indicators = append(alignment_indicators, ' ')
    }
  }
  
  return(alignment_indicators)
}

pretty_print = function (seq1, seq2, aligned_seq1, aligned_seq2, start_position, end_position) {
  # get the pre alignments for both sequences
  pre_alignment_seq1 = get_pre_alignment_vector(seq1, end_position[1] - 1)
  pre_alignment_seq2 = get_pre_alignment_vector(seq2, end_position[2] - 1)
  
  # pad pre alignment with spaces
  max_pre = max(length(pre_alignment_seq1), length(pre_alignment_seq2))
  
  pre_alignment_seq1 = pad_start(pre_alignment_seq1, max_pre)
  pre_alignment_seq2 = pad_start(pre_alignment_seq2, max_pre)
  
  # get the post alignments for both sequences
  post_alignment_seq1 = get_post_alignment_vector(seq1, start_position[1] - 1)
  post_alignment_seq2 = get_post_alignment_vector(seq2, start_position[2] - 1)
  
  # pad post alignment with spaces
  max_post = max(length(post_alignment_seq1), length(post_alignment_seq2))
  
  post_alignment_seq1 = pad_end(post_alignment_seq1, max_post)
  post_alignment_seq2 = pad_end(post_alignment_seq2, max_post)
  
  # construct the sequences using the various parts (pre, aligned, post)
  aligned_seq1 = append(pre_alignment_seq1, c(aligned_seq1, post_alignment_seq1))
  aligned_seq2 = append(pre_alignment_seq2, c(aligned_seq2, post_alignment_seq2))
  
  # get alignment indicators
  alignment_indicators = get_alignment_indicators(aligned_seq1, aligned_seq2)
  
  # transform sequences and indicators to string
  aligned_seq1_str = paste(aligned_seq1, collapse = '')
  aligned_seq2_str = paste(aligned_seq2, collapse = '')
  alignment_indicators_str = paste(alignment_indicators, collapse = '')
  
  return(paste(aligned_seq1_str, alignment_indicators_str, aligned_seq2_str, sep = '\n'))
}
