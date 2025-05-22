library(shiny)
library(tidyverse)
library(lubridate)
library(caret)
library(xgboost)
library(Metrics)
library(plotly)

ui <- fluidPage(
  titlePanel("Bike Rental Demand Forecasting"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload hour.csv", accept = ".csv"),
      actionButton("run", "Run Model")
    ),
    
    mainPanel(
      verbatimTextOutput("rmse_output"),
      plotlyOutput("prediction_plot")
    )
  )
)

server <- function(input, output) {
  observeEvent(input$run, {
    req(input$file)
    
    data <- read.csv(input$file$datapath)
    
    # Feature engineering
    data$datetime <- ymd(data$dteday) + hours(data$hr)
    data$hour <- hour(data$datetime)
    data$month <- month(data$datetime)
    data$wday <- wday(data$datetime, label = TRUE)
    data$wday <- as.numeric(data$wday)
    
    # Select features
    features <- data %>%
      select(cnt, temp, hum, windspeed, season, holiday, workingday,
             weathersit, hour, month, wday)
    
    features <- na.omit(features)
    
    # Train/test split
    set.seed(123)
    train_idx <- createDataPartition(features$cnt, p = 0.8, list = FALSE)
    train_data <- features[train_idx, ]
    test_data <- features[-train_idx, ]
    
    # Linear Model
    lm_model <- train(cnt ~ ., data = train_data, method = "lm")
    lm_preds <- predict(lm_model, newdata = test_data)
    
    # XGBoost
    xgb_train <- xgb.DMatrix(data = as.matrix(sapply(train_data %>% select(-cnt), as.numeric)), label = train_data$cnt)
    xgb_test <- xgb.DMatrix(data = as.matrix(sapply(test_data %>% select(-cnt), as.numeric)))
    
    xgb_model <- xgboost(data = xgb_train, nrounds = 100, objective = "reg:squarederror", verbose = 0)
    xgb_preds <- predict(xgb_model, xgb_test)
    
    # RMSE
    rmse_lm <- rmse(test_data$cnt, lm_preds)
    rmse_xgb <- rmse(test_data$cnt, xgb_preds)
    
    output$rmse_output <- renderPrint({
      cat("Linear Regression RMSE:", round(rmse_lm, 2), "\n")
      cat("XGBoost RMSE:", round(rmse_xgb, 2), "\n")
    })
    
    # Results for plot
    results <- data.frame(
      Index = 1:nrow(test_data),
      Actual = test_data$cnt,
      Linear_Regression = lm_preds,
      XGBoost = xgb_preds
    ) %>%
      pivot_longer(cols = -Index, names_to = "Model", values_to = "Count")
    
    output$prediction_plot <- renderPlotly({
      plot_ly(results, x = ~Index, y = ~Count, color = ~Model, type = 'scatter', mode = 'lines') %>%
        layout(title = "Predicted vs Actual Bike Rentals",
               xaxis = list(title = "Index"),
               yaxis = list(title = "Bike Count"))
    })
  })
}

shinyApp(ui = ui, server = server)

