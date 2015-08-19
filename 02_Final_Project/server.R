# server
library(shiny)
library(stringr)
library(data.table)

source("inputPreparation.R")

shinyServer(function(input, output){

        predict <- reactive({
                txt_in <- input$txt
                clean_txt <- cleanData(txt_in)
                prediction <- word_pred(clean_txt)
        })
        
        output$pred_wrd <- renderText({predict()})
        output$input_txt <- renderText({paste(str_trim(input$txt), predict())})
        
})

