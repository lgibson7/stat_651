

library(tidyverse)
library(shiny)
library(shinybusy)
library(palmerpenguins)

ui <- fluidPage(
  titlePanel("Penguins"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("species", "Species:",
                  choices=unique(penguins$species)),
      selectInput("xvar","X Variable:",
                  choices=setdiff(names(penguins),c("species", "island", "sex", "year"))),
      selectInput("yvar","Y Variable:",
                  choices=setdiff(names(penguins),c("species", "island", "sex", "year"))),
      selectInput("zvar","Z Variable:",
                  choices=c("island", "sex"))
      
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output) {
  
  subData <- reactive({
    penguins %>% 
      filter(species == input$species)
  })
  
  output$plot <- renderPlot(
    ggplot( subData(), aes(x = !!as.name(input$xvar), 
                           y = !!as.name(input$yvar),
                           color = !!as.name(input$zvar))) + geom_point()
  )
  
  
}


shinyApp(ui,server)