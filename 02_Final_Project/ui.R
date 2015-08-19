## ui
library(shiny)

shinyUI(fixedPage(
        titlePanel("Next Word App"),
        
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
                        "which is the final course of the ", 
                        tags$a(href="https://www.coursera.org/specialization/jhudatascience/1?utm_medium=listingPage", 
                               "Data Science specialization course"),
                        "by John Hopkins University on Coursera",
                        "The code used to create this app as well as the slide deck in which the functionality",
                        "and background of this app is explained can be found on this ",
                        tags$a(href="https://github.com/DaanHoevers/Capstone_Project/tree/master/02_Final_Project",
                        "Github page."))
                )
)))

