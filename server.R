## Load the necessary libraries
library(caret)
library(dplyr)
attach(mtcars)

## Define the server logic
server <-function(input, output) {
  
## The purpose of this code is to display the selected variable in the Shiny application's user interface. When the user
## chooses a variable in the "Select Variable" dropdown, the "You have chosen: [selected variable]" message is printed, 
## and the selected variable is displayed in the "id1" output area.
  observeEvent(input$var1, {
    print(paste0("You have chosen: ", input$id2))
  })
  output$id1<-renderText(input$var1)
  
  
## Create a reactive expression called formulaText.  Inside this expression, use the paste function to construct a formula
## for linear regression. The dependent variable "mpg" and the independent variable selected by the user through the input
##element "var1." 
  formulaText <- reactive({
    paste('mpg', "~", input$var1)
  })
  
  Text <- reactive({
    paste('Relation between mpg and', input$var1 , 'by transmission type')
    
  })
## This code ensures that the "caption" text is updated dynamically based on user selections.
  output$caption <- renderText({
    Text()
  })
## The purpose of this code is to dynamically create a caption for the scatterplot and linear regression plot, describing 
## the relationship between "MPG" and the selected variable. The description includes the user-selected variable's name and
## mentions "transmission type."  
  
  output$doc <- renderText({
    "Choose a variable from the dropdown box and view the relationship between the variable and MPG.  Select a transmission 
     type or leave the box empty.  If a transmission type is not chosen, the data will show the relationship between the 
     selected variable and MPG.  The main panel tab shows the scatterplot, boxplot and the related data depending on the 
     variable selected.  Press the submit button each time a variable is selected."
  })
  
  output$preddoc <- renderText({
       "A multiple linear regression model which included all the independent variables, was built.  The details of the model 
    can be seen by clicking on the model summary tab.  The explanatory variables were noted to be am, qsec, and wt.  That 
    is, these variables were statistically significant as they have the lowest p values.  
        By clicking the VarImp tab, the same predictors (am, qsec, and wt ) can be seen as more statistically significant 
    than the other predictors. These three variables were used to build a second model.  By selecting any of these variables
    from the side bar panel, users can see the predicted MPG. Press the submit button each time a variable is selected to 
    view the predicted MPG."
  })
  
  output$results <- renderTable({
    if(input$trans==0){
      mtcars_output=mtcars[mtcars$am==0,]
      
    } else if (input$trans==1){
      mtcars_output=mtcars[mtcars$am==1,]
      
    }else {mtcars_output=mtcars
    }
    
    mtcars_output
  })
  
  output$scatterplot <- renderPlot({
    if(input$trans==0){
      mtcars1=mtcars[mtcars$am==0,]
    } else if (input$trans==1){
      mtcars1=mtcars[mtcars$am==1,]
    }else {mtcars1=mtcars}
    print(plot(as.formula(formulaText()),data=mtcars1) )
  })
  output$boxplot <- renderPlot({
    if(input$trans==0){
      mtcars1=mtcars[mtcars$am==0,]
    } else if (input$trans==1){
      mtcars1=mtcars[mtcars$am==1,]
    }else {mtcars1=mtcars}
    print(boxplot(as.formula(formulaText()),data=mtcars1,ylab ="mpg", xlab =input$var1) )
  }) 
  ## These outputs allow the Shiny application to dynamically display data tables, scatterplots, and boxplots based on user
  ## interactions and choices. The data displayed will vary depending on whether the user selects "automatic" or "manual" 
  ## transmission and which variable is chosen to analyze ("var1"). The code is designed to respond to these inputs and 
  ## provide visualizations accordingly.
  
  #Prediction Tab
  
  model1 <- lm(mpg ~ ., data = mtcars)
  model2 <- lm(mpg ~ am+hp+wt, data = mtcars)
  model2pred <- reactive({
    
    aminput <- as.numeric(input$id1)
    hpinput <- input$id2
    wtinput <- input$id3
    predict(model2, newdata = data.frame(am=aminput,hp=hpinput,wt=wtinput))
    
  })
  
  
  output$summary <- renderPrint ({
    
    summary(model1)
    
  })  
  output$varimp <- renderPrint ({                                                                       
    
    varImp(model1, scale = FALSE)                                                                        
    
  }) 
  
  output$pred2 <- renderText({
    
    model2pred()
    
  })
}
