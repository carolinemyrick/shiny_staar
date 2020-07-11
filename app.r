# Here are the packages I need -----------------------------------------------

library(shiny)
library(ggplot2)
library(tidyverse)
library(here)


# Here's my data --------------------------------------------------------------

staar <- read_csv(here("tapr_for_shiny.csv"))


# Here's the UI portion -------------------------------------------------------

ui <- fluidPage(
  titlePanel("TAPR Scores (practice app)"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("proficiencyOutput"),
      uiOutput("subjectOutput"),
      uiOutput("demogOutput"),
      uiOutput("program_selector"),
      uiOutput("campus_selector")
      
    ),
    mainPanel(
      plotOutput("myplot")
      
    )
  )
)

# Here's the server portion -------------------------------------------------

server <- function(input, output) {
  
  
  output$proficiencyOutput <- renderUI({
    selectInput("proficiencyInput", "Proficiency:",
                sort(unique(staar$proficiency)),
                selected = "meets")
    
  })  
  
  output$subjectOutput <- renderUI({
    selectInput("subjectInput", "Subject:",
                sort(unique(staar$subject)),
                selected = "all")
    
  })  
  
  output$demogOutput <- renderUI({
    selectInput("demogInput", "Student demographic:",
                sort(unique(staar$demog)),
                selected = "all")
    
  }) 
  
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
  
  filtered_data <- reactive(
    
    staar %>%
      filter( proficiency == input$proficiencyInput ) %>%
      filter (subject == input$subjectInput) %>%
      filter (demog == input$demogInput) %>%
      filter (program == input$program)%>%
      filter (campus == input$campus) 
    
  )
  
  output$myplot <- renderPlot({
    ggplot(filtered_data(), aes(year, rate, fill = year)) + 
      geom_bar(position = "dodge", stat = "summary", fun.y = "mean") +
      ylim(0, 100) +
      ylab("% of students") +
      xlab("test year") +
      theme(legend.position = "none")
    
    
    
  })
}


shinyApp(ui = ui, server = server)