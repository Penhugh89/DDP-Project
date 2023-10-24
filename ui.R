## Load the Shiny library  
library(shiny)

## Load the mtcars dataset
data(mtcars)

## Obtain the column names of the dataset
list <- names(mtcars)

## Create a subset of column names to exclude mpg, vs, am, carb and gear                                                                                                                                     
reglist <- setdiff(list, c('am','carb','gear','mpg','vs'))

ui <- shinyUI(fluidPage(
  
## Create a navbarPage with two tab panels: "Data Analysis" and "Prediction Model"
  navbarPage("Data analysis and MPG prediction using Mtcars dataset",
             
## This part of the code sets up the user interface for selecting variables and the transmission type and 
## displaying various types of data analysis outputs based on these choices.
             tabPanel("Data Analysis",
                      sidebarLayout(
                        sidebarPanel(
                          selectInput("var1","Select Variable",choices = reglist),  
                          selectInput("trans", "Select transmission:",
                                      c(" " = 2,
                                        "Manual" = 1,
                                        "Automatic" = 0
                                      ),
                                      selected = NULL ,
                                      multiple = F
                          ),
                          submitButton("Submit"), 
                       
                          h5(textOutput("doc"))
                          
                        ),
                        
                        mainPanel(
                          h3(textOutput("caption")),
                          tabsetPanel(type = "tabs",
                                      tabPanel("Scatterplot", br(), plotOutput("scatterplot")),
                                      tabPanel("Boxplot", br(), plotOutput("boxplot")),
                                      tabPanel("Data", br(), tableOutput("results"))
                          )
                        )
                      ) 
             ),
             
## This section of the code sets up the user interface for selecting input parameters (transmission type, 
## hp, and weight) and displays various types of prediction-related outputs in different tabs.   
             
             tabPanel("Prediction Model", fluid = TRUE,
                      sidebarLayout(
                        sidebarPanel(
                          
                          selectInput("id1", "Select transmission:",
                                      c("Manual" = 1,
                                        "Automatic" = 0
                                      )),
                          sliderInput("id2", 'Enter hp of the car', min = 50, max = 400, value = 50),
                          sliderInput("id3", 'Enter weight of the car', min = 1.0, max = 6.1, value = 1.0),
                          
                          submitButton("Submit"),
                          h5(textOutput("preddoc"))
                          
                        ),
                        mainPanel(
                          tabsetPanel(type = "tabs",
                                      tabPanel("ModelSummary", br(), verbatimTextOutput ("summary")),
                                      tabPanel("VarImp", br(), verbatimTextOutput ("varimp")),                                                                                    
                                      tabPanel("Prediction", br(),textOutput("pred2")))
                          
                        )
                      )
             )
  )
)
)
