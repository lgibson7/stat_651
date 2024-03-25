#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

beatles_names <- c("John", "Paul", "George", "Ringo")

library(tidyverse)
library(mdsr)
library(babynames)
library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  h3("Frequency of Beatles names over time"),
  numericInput("startyear", "Enter starting year", 
               value = 1960, min = 1880, max = 2014, step = 1),
  numericInput("endyear", "Enter ending year",
               value = 1970, min = 1880, max = 2014, step = 1),
  checkboxGroupInput('names', 'Names to display:',
                     sort(unique(beatles_names)),
                     selected = c("Georege", "Paul")),
  plotOutput("plot")
)

Beatles <- babynames %>%
  filter(name %in% c("John", "Paul", "George", "Ringo") & sex == "M")

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$plot <- renderPlot({
    ds <- Beatles %>%
      filter( year >= input$startyear, year <= input$endyear,
              name %in% input$names)
    ggplot(data = ds, aes(x = year, y = prop, color = name)) +
      geom_line(size = 2)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

