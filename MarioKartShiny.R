##### Environments #####
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

##args <- commandArgs(trailingOnly = T)
##port <- as.numeric(args[[1]])


karts <- read.csv('source_data/bodies.csv')
characters <- read.csv('source_data/characters.csv')

Choices.c <- sort(characters$Character)
Choices.k <- sort(karts$Vehicle)


##### UI #####
ui <- fluidPage(theme = shinytheme("slate"),
              navbarPage("Mario Kart 8 Evaluation",
                         tabPanel("Characters",
                                  sidebarLayout(
                                    sidebarPanel(
                                      selectInput("Character.Selector", h3("Character Select"),
                                                  choices = Choices.c, 
                                                  selected = "Baby Daisy")),
                                    mainPanel(plotlyOutput("Character.Plot"))
      )
    ), 
    tabPanel("Karts",
             sidebarLayout(
               sidebarPanel(
                 selectInput("Kart.Selector", h3("Kart Select"),
                             choices = Choices.k, 
                             selected = "B Dasher")),
               mainPanel(plotlyOutput("Kart.Plot"))
      )
    )
  )
)


server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)




