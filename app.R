library(shiny)
source("scoring-matrix.R")
source("traceback.R")
source("pretty-printing.R")
source("utilities.R")

ui = fluidPage(
  
  #
  tags$head(
    tags$title('UNDynamic Local Sequence Alignment Tool'),
    
    # pre means pre-formatted text
    tags$style(HTML(" pre { font-size: 25px} "), '#score{font-size: 42px}', '#Alignmenthead{font-size: 42px}')),
  
  
  titlePanel("UNDynamic Local Sequence Alignment Tool"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      textInput("sequence1", h3("Sequence 1")),
      
      textInput("sequence2", h3("Sequence 2")),
      
      numericInput("gap_open_penalty", h3("Gap opening penalty"), value = 10),
      
      numericInput("gap_extend_penalty", h3("Gap extension penalty"), value = 0.5),
      
      actionButton("run", "Run")
      
    ),
    
    mainPanel(
      
      tableOutput("scoring_matrix"),
      
      textOutput("score"),
      
      textOutput("Alignmenthead"),
      htmlOutput("seq"),
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
    sc_matrix = scoring_matrix(sequence1_vector, sequence2_vector, gap_open_penalty, gap_extend_penalty, subst_matrix)
    #rownames(sc_matrix) = c('-', unlist(strsplit(sequence1, "")))
    #colnames(sc_matrix) = c('-', unlist(strsplit(sequence2, "")))
    
    output$scoring_matrix = renderTable(sc_matrix,
                                        width = "100%",
                                        align = 'c',
                                        bordered = TRUE,
                                        rownames = TRUE,
                                        colnames = TRUE,)
    
    # Traceback and pretty print
    # --------------------------
    traceback_results = traceback_funk(sc_matrix, sequence1_vector, sequence2_vector)
    alignment_score = traceback_results[[2]]
    
    alignment_results = traceback_results[[1]]
    alignment_result = alignment_results[[1]]
    alignment = alignment_result[[1]]
    start_position = alignment_result[[2]]
    end_position = alignment_result[[3]]
    #seq_1 = pretty_print([1])    
    alignment_pretty_printed = pretty_print(
      sequence1_vector,
      sequence2_vector,
      alignment[1,],
      alignment[2,],
      start_position,
      end_position
    )
    
    output$score = renderText({paste('Score:', alignment_score)})
    
    
    output$Alignmenthead = renderText({'Alignments:'})
    output$seq = renderUI({ pre(HTML(paste(alignment_pretty_printed[1], 
                                            alignment_pretty_printed[2], 
                                            alignment_pretty_printed[3], 
                                            sep="<br />"))) })
   # output$match = renderText({ alignment_pretty_printed[2] })
    #output$seq2 = renderText({ alignment_pretty_printed[3] })
  })

}

shinyApp(ui = ui, server = server)
