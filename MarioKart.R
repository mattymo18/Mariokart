##load library
library(shiny)
library(shinydashboard)

##shinyapp

ui <- dashboardPage(
  dashboardHeader(title = "MarioKart"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      box(plotOutput("main_plot", height = 300)),
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
}

shinyApp(ui, server)