##### Environments #####
library(shiny)
library(shinythemes)
library(tidyverse)

args <- commandArgs(trailingOnly = T)
port <- as.numeric(args[[1]])


karts <- read.csv('source_data/karts.csv')
bikes <- read.csv('source_data/bikes.csv')
characters <- read.csv('source_data/characters.csv')

Choices.c <- sort(characters$Character)
Choices.k <- sort(karts$Kart)
Choices.b <- sort(bikes$Bike)


##### UI #####
ui <- fluidPage(theme = shinytheme("slate"),
              navbarPage("Mario Kart Wii",
                        tabPanel("Evaluation Tool", 
                                 sidebarLayout(
                                   sidebarPanel(
                                     radioButtons("Character.1.Type", h3("Select Character 1 Type"), 
                                                  choices = c("Light", "Medium", "Heavy"), 
                                                  selected = "Light", 
                                                  inline = T), 
                                     selectInput("Character.1.Selector", h3("Select Character 1"),
                                                 choices = ""), 
                                     radioButtons("Vehicle.1.Type.Selector", h3("Select Vehicle 1 Type"), 
                                                  choices = c("Bike", "Kart"), 
                                                  selected = "Bike"),
                                     selectInput("Vehicle.1.Selector", h3("Select Vehicle 1"), 
                                                 choices = ""),
                                     radioButtons("Character.2.Type", h3("Select Character 2 Type"), 
                                                  choices = c("Light", "Medium", "Heavy"), 
                                                  selected = "Light", 
                                                  inline = T), 
                                     selectInput("Character.2.Selector", h3("Select Character 2"),
                                                 choices = ""), 
                                     radioButtons("Vehicle.2.Type.Selector", h3("Select Vehicle 2 Type"), 
                                                  choices = c("Bike", "Kart"), 
                                                  selected = "Bike"),
                                     selectInput("Vehicle.2.Selector", h3("Select Vehicle 2"), 
                                                 choices = "")
                                   ),
                                   mainPanel(plotOutput("Eval.Plot")), 
                                   position = "left"
                                 )
                                 
                            )
  )
)

##### Server #####
server <- function(input, output, session) {
#### Selector reactivity #####
  
  ##### Characters #####
  observe({
    xvar = input$Character.1.Type
    updateSelectInput(session, "Character.1.Selector", choices = characters$Character[which(characters$Class == input$Character.1.Type)])
  })  
  
  observe({
    xvar = input$Character.2.Type
    updateSelectInput(session, "Character.2.Selector", choices = characters$Character[which(characters$Class == input$Character.2.Type)])
  }) 
  
  ##### Vehicles #####
  observe({
    if (input$Vehicle.1.Type.Selector == "Bike") {
    xvar = input$Vehicle.1.Type.Selector
    updateSelectInput(session, "Vehicle.1.Selector",
                      choices = bikes$Bike[which(bikes$Class == input$Character.1.Type)])
    } else {
      xvar = input$Vehicle.1.Type.Selector
      updateSelectInput(session, "Vehicle.1.Selector",
                        choices = karts$Kart[which(karts$Class == input$Character.1.Type)])
    }
  })  
  
  observe({
   if (input$Character.1.Selector == input$Character.2.Selector) {
     if (input$Vehicle.2.Type.Selector == "Bike") {
      xvar = input$Vehicle.2.Type.Selector
      updateSelectInput(session, "Vehicle.2.Selector",
                        choices = bikes$Bike[which(bikes$Class == input$Character.2.Type &
                                                     bikes$Bike != input$Vehicle.1.Selector)])
    } else {
      xvar = input$Vehicle.2.Type.Selector
      updateSelectInput(session, "Vehicle.2.Selector",
                        choices = karts$Kart[which(karts$Class == input$Character.2.Type &
                                                     karts$Kart != input$Vehicle.1.Selector)])
    }
   } else {
     if (input$Vehicle.2.Type.Selector == "Bike") {
       xvar = input$Vehicle.2.Type.Selector
       updateSelectInput(session, "Vehicle.2.Selector",
                         choices = bikes$Bike[which(bikes$Class == input$Character.2.Type)])
     } else {
       xvar = input$Vehicle.2.Type.Selector
       updateSelectInput(session, "Vehicle.2.Selector",
                         choices = karts$Kart[which(karts$Class == input$Character.2.Type)])
     }
   }
    
  })
  
#### Plot ####
  
  
  ##### Build DF #####
  
  pivot.bikes <- bikes %>%
    pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo),
                 names_to = "Attribute", values_to = "Vehicle.Score") %>%
    rename("Vehicle" = Bike)

  pivot.karts <- karts %>%
    pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo),
                 names_to = "Attribute", values_to = "Vehicle.Score") %>%
    rename("Vehicle" = Kart)

  pivot.vehicle <- rbind(pivot.bikes, pivot.karts)

  pivot.characters <- characters %>%
    pivot_longer(c(Speed, Weight, Acceleration, Handling, Drift, Off.Road, Mini.Turbo),
                 names_to = "Attribute", values_to = "Score")

  DF <- left_join(pivot.characters, pivot.vehicle)
  Pivot.DF <- DF %>%
    mutate(Final.Score = Score + Vehicle.Score)

     Plot.func <-  reactive({
       ##### Define Inputs #####
       C1.Type <- input$Character.1.Type
       C1.Name <- input$Character.1.Selector
       C1.V <- input$Vehicle.1.Selector
       
       C2.Type <- input$Character.2.Type
       C2.Name <- input$Character.2.Selector
       C2.V <- input$Vehicle.2.Selector 
      
  if(C1.Name != C2.Name)  {
    Pivot.DF %>%
      filter(Class == C1.Type | Class == C2.Type) %>%
      filter(Character == C1.Name | Character == C2.Name) %>%
      filter(Vehicle == C1.V | Vehicle == C2.V) %>%
      ggplot(aes(x=Attribute, y=Final.Score)) +
      geom_bar(aes(fill = Character), stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal() +
      theme(plot.title=element_text(size=18, hjust=0.5, face="bold", color="black", vjust=-1), 
            axis.text = element_text(color = "black")) +
      labs(title = "Evaluation",
           y = 'Rating') +
      scale_fill_brewer(palette="Paired")
  } else {
    Pivot.DF %>%
      filter(Class == C1.Type | Class == C2.Type) %>%
      filter(Character == C1.Name | Character == C2.Name) %>%
      filter(Vehicle == C1.V | Vehicle == C2.V) %>%
      ggplot(aes(x=Attribute, y=Final.Score)) +
      geom_bar(aes(fill = Vehicle), stat = "identity", position = "dodge") +
      coord_flip() +
      theme_minimal() +
      theme(plot.title=element_text(size=18, hjust=0.5, face="bold", color="black", vjust=-1), 
            axis.text = element_text(color = "black")) +
      labs(title = "Evaluation",
           y = 'Rating') +
      scale_fill_brewer(palette="Paired")
  }
  })
  
  output$Eval.Plot <- renderPlot({
    Plot.func()
  })
}

shinyApp(ui = ui, server = server, options = list(port=port,
                                                  host="0.0.0.0"))



