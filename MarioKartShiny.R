##### Environments #####
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

##args <- commandArgs(trailingOnly = T)
##port <- as.numeric(args[[1]])


karts <- read.csv('source_data/karts.csv')
bike <- read.csv('source_data/bikes.csv')
characters <- read.csv('source_data/characters.csv')

Choices.c <- sort(characters$Character)
Choices.k <- sort(karts$Kart)
Choices.b <- sort(bikes$Bike)


##### UI #####
ui <- fluidPage(theme = shinytheme("slate"),
              navbarPage("Mario Kart Wii",
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
                             selected = "Blue Flacon")),
               mainPanel(plotlyOutput("Kart.Plot"))
      )
    ),
    tabPanel("Bikes",
             sidebarLayout(
               sidebarPanel(
                 selectInput("Bike.Selector", h3("Bike Select"),
                             choices = Choices.k, 
                             selected = "Bit Bike")),
               mainPanel(plotlyOutput("Bike.Plot"))
      )
    )
  )
)


server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)




