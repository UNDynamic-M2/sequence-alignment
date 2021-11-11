pretty_print = function(seq_1, seq_2) {
  alignment_str = c()
  
  for(i in 1:length(seq_1)) {
    base1 = seq_1[i]
    base2 = seq_2[i]
    
    if (base1 == base2){
      alignment_str = append(alignment_str, '|')
    } else if (base1 == '-' | base2 == '-'){
      alignment_str = append(alignment_str, ' ')
    } else {
      alignment_str = append(alignment_str, ':')
    }
  }
  
  seq1_str = paste(seq_1, collapse = '')
  seq2_str = paste(seq_2, collapse = '')
  align_str = paste(alignment_str, collapse = '')
  
  return(cat(paste(seq1_str, align_str, seq2_str, sep = '\n')))
}
