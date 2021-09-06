library(shiny)
library(plotly)
library(dplyr)

shinyUI(fluidPage(
    titlePanel("World Map of Covid-19 Deaths"),
    sidebarLayout(
        sidebarPanel(
            h3("Move the sliders to adjust range."),
            sliderInput("Death2020Input", "Deaths 2020", min=0, max=180000, value=c(0,180000)),
            sliderInput("Death2021Input", "Deaths 2021", min=0, max=650000, value=c(0,650000)),
            sliderInput("pGrowthInput", "Percentage Growth", min=0, max=100, value=c(0,100))
        ),
        mainPanel(
            h3("The total number of Covid-19 Deaths up to August 24th 2020 and August 24th 2021"),
            tabsetPanel(type="tabs",
                        tabPanel("2020", plotlyOutput("plot2")),
                        tabPanel("2021", plotlyOutput("plot3")),
                        tabPanel("Percentage Growth", plotlyOutput("plot1"), "Note: percentage growths of 100 or larger 
                                 have all been set to 99."),
                        tabPanel("Help Documentation", "The first three tabs show three respective maps. 
                                 Tab `2020`` and tab `2021`` display the total number of covid deaths recorded up until August 24th 
                                 of the respective years, with a colour key indicating the total number deaths. 
                                 Tab `Percentage Growth` shows the total deaths for both years and the percentage change with 
                                 the colour key indicating the percentage growth.", br(), br(),
                                 "Adjusting the slider will limit the range of the underlying data to only include countries that
                                 fit the limits set by the user.
                                 The first slider adjusts the map on the first tab, the second slider slider adjusts the second tab,
                                  and so on.",
                                 br(), br(),
                                 "As there are outliers and extremes on all three maps, having the sliders allows more precise
                                  comparison, using the colour key, based on what range of values best suits the users desires.", 
                                 br(), br(), 
                                 "Whilst the first and second tabs and associated sliders are just the number of deaths,
                                  the units of the third slider is percentage.")
                        )
        )
    )
))