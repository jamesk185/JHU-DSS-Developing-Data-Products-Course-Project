library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(
    titlePanel("World Map of Covid-19 Deaths"),
    sidebarLayout(
        sidebarPanel(
            h3("Change the sliders to filter to the selected range, with the colour key automatically adjusting."),
            sliderInput("Death2020Input", "Deaths 2020", min=0, max=180000, value=c(0,180000)),
            sliderInput("Death2021Input", "Deaths 2021", min=0, max=650000, value=c(0,650000)),
            sliderInput("pGrowthInput", "Percentage Growth", min=0, max=100, value=c(0,100)),
        ),
        mainPanel(
            h3("The total number of Covid-19 Deaths up to August 24th 2020 and August 24th 2021"),
            tabsetPanel(type="tabs",
                        tabPanel("2020", plotlyOutput("plot2")),
                        tabPanel("2021", plotlyOutput("plot3")),
                        tabPanel("Percentage Growth", plotlyOutput("plot1"), "Note: percentage growths of 100 or larger have all been set to 99.")
                        )
        )
    )
))
