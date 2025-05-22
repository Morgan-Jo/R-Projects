# Load libraries
library(shiny)
library(tidyverse)
library(lubridate)
library(caret)
library(xgboost)
library(Metrics)
library(ggplot2)

# Load and preprocess data
bike_data <- read.csv("day.csv")
bike_data$dteday <- as.Date(bike_data$dteday)
bike_data$day <- day(bike_data$dteday)
bike_data$month <- month(bike_data$dteday)
bike_data$year <- year(bike_data$dteday)
bike_data$weekday <- wday(bike_data$dteday, label = TRUE)
bike_data <- bike_data %>% select(-instant, -casual, -registered)

# Train/test split
set.seed(123)
train_index <- createDataPartition(bike_data$cnt, p = 0.8, list = FALSE)
train_data <- bike_data[train_index, ]
test_data <- bike_data[-train_index, ]

# Train linear regression model
lm_model <- train(cnt ~ ., data = train_data, method = "lm")
lm_pred <- predict(lm_model, newdata = test_data)
lm_rmse <- rmse(test_data$cnt, lm_pred)

# Train XGBoost model
train_matrix <- model.matrix(cnt ~ . -1, data = train_data)
test_matrix <- model.matrix(cnt ~ . -1, data = test_data)
dtrain <- xgb.DMatrix(data = train_matrix, label = train_data$cnt)
dtest <- xgb.DMatrix(data = test_matrix, label = test_data$cnt)
xgb_model <- xgboost(data = dtrain, nrounds = 100, objective = "reg:squarederror", verbose = 0)
xgb_pred <- predict(xgb_model, dtest)
xgb_rmse <- rmse(test_data$cnt, xgb_pred)

# Prepare results dataframe
results <- data.frame(
  Date = test_data$dteday,
  Actual = test_data$cnt,
  LM_Predicted = lm_pred,
  XGB_Predicted = xgb_pred
)

# UI
ui <- fluidPage(
  titlePanel("🚲 Bike Rental Demand Forecasting"),
  sidebarLayout(
    sidebarPanel(
      selectInput("model", "Choose a Model:",
                  choices = c("Linear Regression" = "LM_Predicted",
                              "XGBoost" = "XGB_Predicted")),
      hr(),
      verbatimTextOutput("rmse")
    ),
    mainPanel(
      plotOutput("predictionPlot", height = "400px")
    )
  )
)

# Server
server <- function(input, output) {
  
  output$rmse <- renderPrint({
    if (input$model == "LM_Predicted") {
      cat("Linear Regression RMSE:", round(lm_rmse, 2))
    } else {
      cat("XGBoost RMSE:", round(xgb_rmse, 2))
    }
  })
  
  output$predictionPlot <- renderPlot({
    model_col <- input$model
    plot_data <- results %>%
      select(Date, Actual, model = all_of(model_col))
    
    ggplot(plot_data, aes(x = Date)) +
      geom_line(aes(y = Actual, color = "Actual")) +
      geom_line(aes(y = model, color = model_col)) +
      labs(title = paste("Bike Rentals -", gsub("_", " ", model_col)),
           y = "Rental Count", color = "Legend") +
      theme_minimal()
  })
}

# Run the app
shinyApp(ui = ui, server = server)

