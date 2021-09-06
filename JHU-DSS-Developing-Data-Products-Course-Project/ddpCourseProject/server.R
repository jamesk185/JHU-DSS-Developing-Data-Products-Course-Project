library(shiny)
library(plotly)
library(dplyr)

shinyServer(function(input, output) {
    
    URL2020 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/08-24-2020.csv"
    URL2021 <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/08-24-2021.csv"
    URLcountries <- "https://raw.githubusercontent.com/albertyw/avenews/master/old/data/average-latitude-longitude-countries.csv"
    
    if(!file.exists("./08-24-2020.csv")){download.file(URL2020, "./08-24-2020.csv")}
    if(!file.exists("./08-24-2021.csv")){download.file(URL2021, "./08-24-2021.csv")}
    if(!file.exists("./countries.csv")){download.file(URLcountries, "./countries.csv")}
    
    data2020 <- read.csv("./08-24-2020.csv")
    data2021 <- read.csv("./08-24-2021.csv")
    countries <- read.csv("./countries.csv")
    
    levels(countries$Country)[levels(countries$Country)=="United States"] <- "US"
    levels(countries$Country)[levels(countries$Country)=="Myanmar"] <- "Burma"
    levels(countries$Country)[levels(countries$Country)=="Cape Verde"] <- "Cabo Verde"
    levels(countries$Country)[levels(countries$Country)=="Congo"] <- "Congo (Brazzaville)"
    levels(countries$Country)[levels(countries$Country)=="Congo, The Democratic Republic of the"] <- "Congo (Kinshasa)"
    levels(countries$Country)[levels(countries$Country)=="Czech Republic"] <- "Czechia"
    levels(countries$Country)[levels(countries$Country)=="Swaziland"] <- "Eswatini"
    levels(countries$Country)[levels(countries$Country)=="Iran, Islamic Republic of"] <- "Iran"
    levels(countries$Country)[levels(countries$Country)=="Korea, Republic of"] <- "Korea, South"
    levels(countries$Country)[levels(countries$Country)=="Lao People's Democratic Republic"] <- "Laos"
    levels(countries$Country)[levels(countries$Country)=="Libyan Arab Jamahiriya"] <- "Libya"
    levels(countries$Country)[levels(countries$Country)=="Moldova, Republic of"] <- "Moldova"
    levels(countries$Country)[levels(countries$Country)=="Russian Federation"] <- "Russia"
    levels(countries$Country)[levels(countries$Country)=="Syrian Arab Republic"] <- "Syria"
    levels(data2020$Country_Region)[levels(data2020$Country_Region)=="Taiwan*"] <- "Taiwan"
    levels(data2021$Country_Region)[levels(data2021$Country_Region)=="Taiwan*"] <- "Taiwan"
    levels(countries$Country)[levels(countries$Country)=="Tanzania, United Republic of"] <- "Tanzania"
    levels(countries$Country)[levels(countries$Country)=="Palestinian Territory"] <- "West Bank and Gaza"
    
    missCountries <- data.frame(ISO.3166.Country.Code = c("NM", "KO", "SS"), 
                                Country = c("North Macedonia", "Kosovo", "South Sudan"), 
                                Latitude = c(41.6086, 42.6026, 6.8770), 
                                Longitude = c(21.7453, 20.9030, 31.3070))
    
    countries <- rbind(countries, missCountries)
    
    country_names_2020 <- unique(data2020$Country_Region)
    
    df1 <- data.frame(country = NULL, death_total_2020 = NULL)
    for (x in country_names_2020){
        death_total_2020 <- sum(data2020[data2020$Country_Region==x,]$Deaths)
        country <- country_names_2020[country_names_2020==x]
        df1 <- rbind(df1, c(country, death_total_2020))
    }
    
    df1 <- cbind(Country = as.character(country_names_2020), df1) %>%
        select(-2) %>% 
        rename(Deaths_2020 = 2)
    
    country_names_2021 <- unique(data2021$Country_Region)
    
    df2 <- data.frame(country = NULL, death_total_2021 = NULL)
    for (x in country_names_2021){
        death_total_2021 <- sum(data2021[data2021$Country_Region==x,]$Deaths)
        country <- country_names_2021[country_names_2021==x]
        df2 <- rbind(df2, c(country, death_total_2021))
    }
    
    df2 <- cbind(Country = as.character(country_names_2021), df2) %>%
        select(-2) %>% 
        rename(Deaths_2021 = 2)
    
    df3 <- merge(df1, df2, all = FALSE) %>% 
        mutate(Percentage_Growth = signif(Deaths_2021/Deaths_2020, 3))
    
    df4 <- merge(countries, df3, all = FALSE) %>% 
        select(-2) %>%
        rename(lat = 2, lng = 3)
    

    output$plot1 <- renderPlotly({
    
            lowerpvalue <- input$pGrowthInput[1]
            upperpvalue <- input$pGrowthInput[2]
            
            df5 <- df4
        
            df5$Percentage_Growth[is.na(df5$Percentage_Growth)] <- 0
            df5$Percentage_Growth[df5$Percentage_Growth > 99] <- 99
            df5$Percentage_Growth[df5$Percentage_Growth==Inf] <- 99
            
            
            df5 <- df5 %>% filter(Percentage_Growth<upperpvalue, Percentage_Growth>lowerpvalue)
        
        plot_ly(df5, type='scattergeo', mode='markers', lat=df5$lat, lon=df5$lng, color = df5$Percentage_Growth,
                       text=~paste0(Country, "<br> Deaths 2020: ",Deaths_2020, "<br> Deaths 2021: ",Deaths_2021, "<br> Percentage Growth: ", Percentage_Growth))
        
        })
    
    output$plot2 <- renderPlotly({
        
        lowerd1value <- input$Death2020Input[1]
        upperd1value <- input$Death2020Input[2]
        
        df5 <- df4 
        
        df5 <- df5 %>% filter(Deaths_2020<upperd1value, Deaths_2020>lowerd1value)
        
        plot_ly(df5, type='scattergeo', mode='markers', lat=df5$lat, lon=df5$lng, color = df5$Deaths_2020,
                text=~paste0(Country, "<br> Deaths 2020: ",Deaths_2020))
        
    })
    
    output$plot3 <- renderPlotly({
        
        lowerd2value <- input$Death2021Input[1]
        upperd2value <- input$Death2021Input[2]
        
        df5 <- df4 
        
        df5 <- df5 %>% filter(Deaths_2021<upperd2value, Deaths_2021>lowerd2value)
        
        plot_ly(df5, type='scattergeo', mode='markers', lat=df5$lat, lon=df5$lng, color = df5$Deaths_2021,
                text=~paste0(Country, "<br> Deaths 2021: ",Deaths_2021))
        
    })
    

})
