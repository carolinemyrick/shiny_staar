library(shiny)
library(shinydashboard)
##
staar <- read.csv(here("tapr_for_shiny.csv"))

options(stringsAsFactors = FALSE)

ui <- shinyUI({
  sidebarPanel(
    
    uiOutput("program_selector"),
    uiOutput("campus_selector"))
  
})
##
server <- shinyServer(function(input, output) {
  
  output$program_selector <- renderUI({
    
    selectInput(
      inputId = "program", 
      label = "Program:",
      choices = as.character(unique(staar$program)),
      selected = "ALP")
    
  })
  
  output$campus_selector <- renderUI({
    
    available <- staar[staar$program == input$program, "campus"]
    selectInput(
      inputId = "campus", 
      label = "Campus:",
      choices = unique(available),
      selected = unique(available)[1])
    
  })
  
})
##
shinyApp(ui = ui, server = server)