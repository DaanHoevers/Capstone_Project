## ui
library(shiny)

shinyUI(fixedPage(
        titlePanel("Predicting the Next Word"),
        
        fluidRow(
                helpText("This app takes the input of a phrase of words and predicts the next word for you.")
                ),
        
        fluidRow(
                column(6, wellPanel(
                        textInput("txt", label = h5("Text Input"), value = "Enter Text...")
                )),
                column(6, wellPanel(
                       h5("Next word"), verbatimTextOutput("pred_wrd"),
                       h5("Output phrase"), verbatimTextOutput("input_txt")
                )),
#         hr(),
#         hr(),        
#         hr(),
#         hr(),
#         hr(),
#         hr(),
        fluidRow(
                
                helpText("This report is made as part of the final report of the Capstone project",
                        "which is the final course of ", 
                        tags$a(href="https://www.coursera.org/specialization/jhudatascience/1?utm_medium=listingPage", 
                               "the Data Science specialization course"),
                        "by John Hopkins University on Coursera")
                )
)))

