library(shiny)
source("scoring-matrix.R")
source("utilities.R")

ui = fluidPage(
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
      
      tableOutput("scoring_matrix")
      
    )
  )
)

server = function (input, output) {
  
  observeEvent(input$run, {
    print(input$sequence1)
    print(input$sequence2)
    
    sequence1 = input$sequence1
    sequence2 = input$sequence2
    gap_open_penalty = input$gap_open_penalty
    gap_extend_penalty = input$gap_extend_penalty
    subst_matrix = get_default_substitution_matrix()
    
    sc_matrix = scoring_matrix(sequence1, sequence2, gap_open_penalty, gap_extend_penalty, subst_matrix)
    rownames(sc_matrix) = c('-', unlist(strsplit(sequence1, "")))
    colnames(sc_matrix) = c('-', unlist(strsplit(sequence2, "")))
    
    output$scoring_matrix = renderTable(sc_matrix)
  })

}

shinyApp(ui = ui, server = server)
