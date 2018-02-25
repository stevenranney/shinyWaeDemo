

library(ggplot2)
library(dplyr)

  wae <- read.table('data/WAE Clean.txt', header=T)
  
  shinyServer(function(input, output) {

    dataset <- reactive( {
      df <- wae[sample(nrow(wae), input$sampleSize, replace=TRUE), ]
      return(df)
    })

    #Create the least-squares regression model
    lmMod <- reactive({
      lm(log10(Weight)~log10(Length), data = dataset())
    })
    
    #Create the quantile regression model
    quantMod <- reactive({
      rq(log10(Weight)~log10(Length), data = dataset(), tau=input$tau)
    })
    
    output$plot <- renderPlot({
      
      lin_plot <- 
        ggplot(data = dataset(),
               aes(x = log10(Length), y = log10(Weight))) +
        geom_point(alpha = 0.5) +
        labs(x = "Length (mm)", y = "Weight (g)")
      
      if(input$linear == FALSE){
        ggplot(data = dataset(), 
             aes(x = Length, y = Weight)) +
        geom_point(alpha = 0.5) +
        labs(x = "Length (mm)", y = "Weight (g)")
      } else {

        ggplot(data = dataset(),
               aes(x = log10(Length), y = log10(Weight))) +
          geom_point(alpha = 0.5) +
          labs(x = "Length (mm)", y = "Weight (g)")
        if(input$ols){
            ggplot(data = dataset(),
                   aes(x = log10(Length), y = log10(Weight))) +
              geom_point(alpha = 0.5) +
              labs(x = "Length (mm)", y = "Weight (g)") +
              geom_abline(intercept = lmMod()$coefficients[1],
                          slope = lmMod()$coefficients[2],
                          colour = "red", lwd = 1)}
          # if(input$qr){
          #   ggplot(data = dataset(),
          #          aes(x = log10(Length), y = log10(Weight))) +
          #     geom_point(alpha = 0.5) +
          #     labs(x = "Length (mm)", y = "Weight (g)") +
          #     geom_abline(intercept = quantMod()$coefficients[1],
          #                 slope = quantMod()$coefficients[2],
          #                 colour = "blue", lwd = 1)}
      }
      
      # if(input$linear){
      #     if(input$ols){
      #       ggplot(data = dataset(),
      #              aes(x = log10(Length), y = log10(Weight))) +
      #         geom_point(alpha = 0.5) +
      #         labs(x = "Length (mm)", y = "Weight (g)") +
      #         geom_abline(intercept = lmMod()$coefficients[1],
      #                     slope = lmMod()$coefficients[2],
      #                     colour = "red", lwd = 1)}
      #       if(input$qr){
      #         ggplot(data = dataset(),
      #                aes(x = log10(Length), y = log10(Weight))) +
      #           geom_point(alpha = 0.5) +
      #           labs(x = "Length (mm)", y = "Weight (g)") +
      #           geom_abline(intercept = quantMod()$coefficients[1],
      #                       slope = quantMod()$coefficients[2],
      #                       colour = "blue", lwd = 1)}
      #   }
          
        
      }) #Close renderPlot statement
    
    }) #Close shiny statement


      

    
        

     

  
    