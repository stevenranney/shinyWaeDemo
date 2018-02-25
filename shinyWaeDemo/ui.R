  
  library(shiny)
  library(quantreg)
  library(ggplot2)
  library(dplyr)
  
  wae <- read.table('data/WAE Clean.txt', header=T)
  
  #  dataset <- wae
  

  shinyUI(pageWithSidebar(
  
    headerPanel("Walleye weight vs. length"),
  
    sidebarPanel(
    
      sliderInput('sampleSize', 'Sample Size', min=50, max=nrow(wae),
                  value=min(1000, nrow(wae)), step=50, round=0),
    
      checkboxInput('linear', 'Linear'),
      checkboxInput('ols', 'Display linear least-squares regression'),
      checkboxInput('qr', 'Display quantile regression'),
      
      sliderInput('tau', 'Quantile', min=0.01, max=0.99, value=0.5, step=0.01),
      em("Regression equations are implemented for linearized data only.")
#      checkboxInput('doICare', "I don't care about modeling fisheries data.")
    
    ),
  
    mainPanel(
      plotOutput('plot')
    )
  ))