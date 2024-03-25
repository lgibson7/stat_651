# Shiny app for the violations data

library(tidyverse)
library(shiny)
library(shinybusy)
library(mdsr)

mergedViolations <- Violations %>%
  left_join(Cuisines)

ui <- fluidPage(
  titlePanel("Restaurant Explorer"),
  fluidRow(
    # some things take time: this lets users know
    add_busy_spinner(spin = "fading-circle"),
    column(4, selectInput(inputId = "boro",
                  label = "Borough:",
                  choices = c(
                    "ALL",
                    unique(as.character(mergedViolations$boro))
                  )
      )
    ),
    # display dynamic list of cuisines
    column(4, uiOutput("cuisinecontrols"))
  ),
  # Create a new row for the table.
  fluidRow(
    DT::dataTableOutput("table")
  )
)

server <- function(input, output) {
  datasetboro <- reactive({  # Filter data based on selections
    data <- mergedViolations %>%
      select(
        dba, cuisine_code, cuisine_description, street,
        boro, zipcode, score, violation_code, grade_date
      ) %>%
      group_by(boro, cuisine_description) %>% 
      summarize(n = n_distinct(dba)) 
    req(input$boro)  # wait until there's a selection
    if (input$boro != "ALL") {
      data <- data %>%
        filter(boro == input$boro)
    }
    data
  })
  
  datasetcuisine <- reactive({  # dynamic list of cuisines
    req(input$cuisine)   # wait until list is available
    data <- datasetboro() %>%
      unique()
    if (input$cuisine != "ALL") {
      data <- data %>%
        filter(cuisine_description == input$cuisine)
    }
    data
  })
  
  output$table <- DT::renderDataTable(DT::datatable(datasetcuisine()))
  
  output$cuisinecontrols <- renderUI({
    availablelevels <-
      unique(sort(as.character(datasetboro()$cuisine_description)))
    selectInput(
      inputId = "cuisine",
      label = "Cuisine:",
      choices = c("ALL", availablelevels)
    )
  })
}

shinyApp(ui = ui, server = server)