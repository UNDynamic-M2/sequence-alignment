library(shiny)
source("scoring-matrix.R")
source("traceback.R")
source("pretty-printing.R")
source("utilities.R")

ui = fluidPage(
  
  tags$head(
    
    # Title
    tags$title('UNDynamic Local Sequence Alignment Tool'),
    
    # Styling pre-formatted text
    tags$style(HTML(" pre { font-size: 25px} "), '#score{font-size: 42px}', '#Alignmenthead{font-size: 42px}')),
  
  
  titlePanel("UNDynamic Local Sequence Alignment Tool"),
  
  sidebarLayout(
    
    # Inputs
    #-------
    sidebarPanel(
      
      # Input sequences
      textInput("sequence1", h3("Sequence 1")),
      textInput("sequence2", h3("Sequence 2")),
      
      # Input gap penalties
      numericInput("gap_open_penalty", h3("Gap opening penalty"), value = 10),
      numericInput("gap_extend_penalty", h3("Gap extension penalty"), value = 0.5),
      
      actionButton("run", "Run")
      
    ),
    
    # Outputs
    #--------
    mainPanel(
      
      # Output scoring matrix
      tableOutput("scoring_matrix"),
      
      # Output overall score
      textOutput("score"),
      
      # Output the aligned sequences
      textOutput("Alignmenthead"),
      htmlOutput("seq"),
      textOutput('pathway')
      #htmlOutput("match"),
      #htmlOutput("seq2")
      
    )
  )
)

server = function (input, output) {
  
  observeEvent(input$run, {
    print(input$sequence1)
    print(input$sequence2)
    
    sequence1 = input$sequence1
    sequence2 = input$sequence2
    sequence1_vector = unlist(strsplit(sequence1, split = ""))
    sequence2_vector = unlist(strsplit(sequence2, split = ""))
    gap_open_penalty = input$gap_open_penalty
    gap_extend_penalty = input$gap_extend_penalty
    subst_matrix = get_default_substitution_matrix()
    
    # Scoring matrix
    # --------------
    
    # Inputs for scoring matrix
    sc_matrix = scoring_matrix(sequence1_vector, sequence2_vector, gap_open_penalty, gap_extend_penalty, subst_matrix)
      #rownames(sc_matrix) = c('-', unlist(strsplit(sequence1, "")))
      #colnames(sc_matrix) = c('-', unlist(strsplit(sequence2, "")))
    
    # Format scoring matrix
    output$scoring_matrix = renderTable(sc_matrix,
                                        width = "100%",
                                        align = 'c',
                                        bordered = TRUE,
                                        rownames = TRUE,
                                        colnames = TRUE,)
    
   
    # Traceback and pretty print
    # --------------------------
    
    # Summon results of traceback function, inputted with the scoring matrix and both sequences
    traceback_results = traceback_funk(sc_matrix, sequence1_vector, sequence2_vector)

    # Summon alignment_matrix, start_position, end_position and pathway from traceback_results
    
    alignment_results = traceback_results[[1]]
    
    pretty_print_list = list()
    
    for(i in 1:length(alignment_results)) {
    # Summon results for each starting position
      alignment_result = alignment_results[[i]]
      
      alignment = alignment_result[[1]]
      start_position = alignment_result[[2]]
      end_position = alignment_result[[3]]
      
      pathway_result = alignment_result[[4]]
      pathway_vec = c()
      
      for(z in 1:ncol(pathway_result)) {
        pathway_vec = append(pathway_vec, paste(pathway_result[,z],collapse = ","))      
         }
      
      # Input sequences, alignments and starting and end positions into pretty_print function
      alignment_pretty_printed = pretty_print(
        sequence1_vector,
        sequence2_vector,
        alignment[1,],
        alignment[2,],
        start_position,
        end_position
      ) 
      
      
      pretty_print_list[[i]] = paste(alignment_pretty_printed[1], 
                                     alignment_pretty_printed[2], 
                                     alignment_pretty_printed[3],
                                     paste(pathway_vec, collapse = " -> "),
                                     sep="<br />"
                                     )
    }
    
    pretty_print_list_str = paste(pretty_print_list, collapse = "<br /><br />")
      
  
      output$Alignmenthead = renderText({'Alignments:'})
      output$seq = renderUI({ pre(HTML(pretty_print_list_str)) })
      
    
    
     # for (i in 1:dim(pathway_result)[2]) {
        
      #  output$pathway = renderText({ 
         
       #    pathway[i]})
        
      #}
      
    
    # Summon score and output
    alignment_score = traceback_results[[2]]
    output$score = renderText({paste('Score:', alignment_score)})
 
  })

}

shinyApp(ui = ui, server = server)
