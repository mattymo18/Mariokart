##### Environments #####
library(shiny)
library(shinythemes)
library(tidyverse)
library(plotly)

##args <- commandArgs(trailingOnly = T)
##port <- as.numeric(args[[1]])


karts <- read.csv('source_data/karts.csv')
bikes <- read.csv('source_data/bikes.csv')
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
                                      selectInput("Character.Selector1", h3("Character Select 1"),
                                                  choices = Choices.c, 
                                                  selected = "Baby Daisy"),
                                      selectInput("Character.Selector2", h3("Character Select 2"),
                                                choices = "")),
                                    mainPanel(plotlyOutput("Character.Plot"))
      )
    ), 
                        tabPanel("Karts",
                               sidebarLayout(
                                 sidebarPanel(
                                   radioButtons("Kart.Selector.Type1", h3("Select Kart Type 1"),
                                               choices = c("Light", "Medium", "Heavy"), 
                                               selected = "Light", 
                                               inline = T), 
                                   selectInput("Kart.Selector1", h3("Kart Select 1"),
                                               choices = Choices.k, 
                                               selected = "Blue Flacon"),
                                   radioButtons("Kart.Selector.Type2", h3("Select Kart Type 2"),
                                                choices = c("Light", "Medium", "Heavy"), 
                                                selected = "Light", 
                                                inline = T),
                                   selectInput("Kart.Selector2", h3("Kart Select 2"),
                                               choices = "")),
                                 mainPanel(plotlyOutput("Kart.Plot"))
      )
    ),
                        tabPanel("Bikes",
                                 sidebarLayout(
                                   sidebarPanel(
                                     radioButtons("Bike.Selector.Type1", h3("Select Bike Type 1"),
                                                 choices = c("Light", "Medium", "Heavy"), 
                                                 selected = "Light", 
                                                 inline = T),
                                     selectInput("Bike.Selector1", h3("Bike Select 1"),
                                                 choices = Choices.b, 
                                                 selected = "Bit Bike"),
                                     radioButtons("Bike.Selector.Type2", h3("Select Bike Type 2"),
                                                  choices = c("Light", "Medium", "Heavy"), 
                                                  selected = "Light", 
                                                  inline = T),
                                     selectInput("Bike.Selector2", h3("Bike Select 2"),
                                                 choices = "")),
                                   mainPanel(plotlyOutput("Bike.Plot"))
      )
    )
  )
)

##### Server #####
server <- function(input, output, session) {
#### Selector reactivity #####
  
  ##### Characters #####
  observe({
    xvar = input$Character.Selector1
    updateSelectInput(session, "Character.Selector2", choices = Choices.c[-which(Choices.c == input$Character.Selector1)])
  }) 
  
  observe({
    xvar = input$Kart.Selector.Type1
    updateSelectInput(session, "Kart.Selector1", choices = karts$Kart[which(karts$Class == input$Kart.Selector.Type1)])
  })   
  
  ##### Karts #####
  observe({
    xvar = input$Kart.Selector.Type2
    updateSelectInput(session, "Kart.Selector2", choices = karts$Kart[which(karts$Class == input$Kart.Selector.Type2)])
  })
  
  observe({
    if (input$Kart.Selector.Type1 == input$Kart.Selector.Type2) {
    xvar = input$Kart.Selector1
    updateSelectInput(session, "Kart.Selector2", choices = karts$Kart[which(karts$Class == input$Kart.Selector.Type1 &
                                                                              karts$Kart != input$Kart.Selector1)])
    }
  }) 
  
  ##### Bikes #####
  observe({
    xvar = input$Bike.Selector.Type1
    updateSelectInput(session, "Bike.Selector1", choices = bikes$Bike[which(bikes$Class == input$Bike.Selector.Type1)])
  }) 
  
  observe({
    xvar = input$Bike.Selector.Type2
    updateSelectInput(session, "Bike.Selector2", choices = bikes$Bike[which(bikes$Class == input$Bike.Selector.Type2)])
  }) 
  
  observe({
    if (input$Bike.Selector.Type1 == input$Bike.Selector.Type2) {
    xvar = input$Bike.Selector1
    updateSelectInput(session, "Bike.Selector2", choices = bikes$Bike[which(bikes$Class == input$Bike.Selector.Type1 &
                                                                              bikes$Bike != input$Bike.Selector1)])
    }
  }) 
  
#### Plots ####
  
  output$Character.Plot <- renderPlotly({
    
    xvar <- input$Character.Selector1
    yvar <- input$Character.Selector2
    
    characters %>% 
      pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo), 
                   names_to = "Attribute", values_to = "Score") %>% 
      filter(Character == xvar | Character == yvar) %>% 
      ggplot(aes(x=Attribute, y=ifelse(Score == 0, -.025, Score))) +
      geom_bar(aes(fill = Character), stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal() + 
      theme(plot.title=element_text(size=18, hjust=0.5, face="bold", colour="black", vjust=-1)) +
      labs(title = "Character Evaluator", 
           y = 'Rating') +
      scale_fill_brewer(palette="Paired")
  })
  
  output$Kart.Plot <- renderPlotly({
    
    xvar <- input$Kart.Selector1
    yvar <- input$Kart.Selector2
    
    karts %>% 
      pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo), 
                   names_to = "Attribute", values_to = "Score") %>% 
      filter(Kart == xvar | Kart == yvar) %>% 
      ggplot(aes(x=Attribute, y=ifelse(Score == 0, -.025, Score))) +
      geom_bar(aes(fill = Kart), stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal() + 
      theme(plot.title=element_text(size=18, hjust=0.5, face="bold", colour="black", vjust=-1)) +
      labs(title = "Kart Evaluator", 
           y = 'Rating') +
      scale_fill_brewer(palette="Paired")
  })
  
  output$Bike.Plot <- renderPlotly({
    
    xvar <- input$Bike.Selector1
    yvar <- input$Bike.Selector2
    
    bikes %>% 
      pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo), 
                   names_to = "Attribute", values_to = "Score") %>% 
      filter(Bike == xvar | Bike == yvar) %>% 
      ggplot(aes(x=Attribute, y=ifelse(Score == 0, -.025, Score))) +
      geom_bar(aes(fill = Bike), stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal() + 
      theme(plot.title=element_text(size=18, hjust=0.5, face="bold", colour="black", vjust=-1)) +
      labs(title = "Bike Evaluator", 
           y = 'Rating') +
      scale_fill_brewer(palette="Paired")
  })
}

shinyApp(ui = ui, server = server)




