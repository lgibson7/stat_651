#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(macleish)
library(tidyverse)
library(ggplot2)
library(lubridate)

# Define UI for dataset viewer app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Macleish"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing dataset ----
      selectInput(inputId = "dataset",
                  label = "Choose a dataset:",
                  choices = c("whately_2015", "orchard_2015")),
      
      # Input: Numeric entry for number of obs to view ----
      numericInput(inputId = "obs",
                   label = "Number of observations to view:",
                   value = 5)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),
      
      # Output: HTML table with requested number of observations ----
      tableOutput("view"),
      
      # Output: plot
      plotOutput("plot")
      
      )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "whately_2015" = whately_2015,
           "orchard_2015" = orchard_2015)
  })
  
  # Show the first "n" observations ----
  output$view <- renderTable({
    head(datasetInput()[,1:2], n = input$obs)
  })
  
  # Generate a summary of the dataset ----
  output$summary <- renderPrint({
    dataset <- datasetInput()[,1:2]
    summary(dataset)
  })
  

  output$plot <- renderPlot({
    plot(datasetInput()[,1:2], type="l")
  })
  
  seasons_2015 <- tibble(
    when = as.Date(ymd(c("2015 March 20", "2015 June 21", "2015 September 23", "2015 December 21"))),
    season = c("Spring", "Summer", "Fall", "Winter")
  )
  
  output$plot <- renderPlot({
    datasetInput() %>% ggplot(aes(y = temperature, x = as.Date(when))) +
      geom_vline(data = seasons_2015, color = "darkgray", aes( xintercept = as.numeric(when) ) ) +
      geom_text(data = seasons_2015, aes(y = 33, label = season, hjust = "right")) +
      geom_line(size = 0.3) + 
      geom_smooth() +
      scale_x_date() +
      ggtitle("Tempurature")
  })
  
#  output$plot <- renderPlot({
#    datasetInput() %>% ggplot(aes(x = when, y = temperature)) +
#      geom_line() +
#      ggtitle("Tempurature")
#  })
  
}

# Create Shiny app ----
shinyApp(ui, server)