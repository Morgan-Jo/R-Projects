# Load required libraries
library(tidyverse)
library(lubridate)
library(caret)
library(xgboost)
library(Metrics)
library(ggplot2)

# Load the dataset
bike_data <- read.csv("day.csv")

# Inspect data
glimpse(bike_data)

# Convert date to Date type and extract datetime features
bike_data$dteday <- as.Date(bike_data$dteday)
bike_data$day <- day(bike_data$dteday)
bike_data$month <- month(bike_data$dteday)
bike_data$year <- year(bike_data$dteday)
bike_data$weekday <- wday(bike_data$dteday, label = TRUE)

# Drop unused columns
bike_data <- bike_data %>% select(-instant, -casual, -registered)

# Train-Test Split (80-20)
set.seed(123)
train_index <- createDataPartition(bike_data$cnt, p = 0.8, list = FALSE)
train_data <- bike_data[train_index, ]
test_data <- bike_data[-train_index, ]

# Train a linear regression model
lm_model <- train(cnt ~ ., data = train_data, method = "lm")
lm_pred <- predict(lm_model, newdata = test_data)
lm_rmse <- rmse(test_data$cnt, lm_pred)

# Prepare data for XGBoost
train_matrix <- model.matrix(cnt ~ . -1, data = train_data)
test_matrix <- model.matrix(cnt ~ . -1, data = test_data)

dtrain <- xgb.DMatrix(data = train_matrix, label = train_data$cnt)
dtest <- xgb.DMatrix(data = test_matrix, label = test_data$cnt)

# Train XGBoost model
xgb_model <- xgboost(data = dtrain, nrounds = 100, objective = "reg:squarederror", verbose = 0)
xgb_pred <- predict(xgb_model, dtest)
xgb_rmse <- rmse(test_data$cnt, xgb_pred)

# Model Performance
cat("Linear Regression RMSE:", round(lm_rmse, 2), "\n")
cat("XGBoost RMSE:", round(xgb_rmse, 2), "\n")

# Plot predictions
results <- data.frame(Date = test_data$dteday, Actual = test_data$cnt,
                      LM_Predicted = lm_pred, XGB_Predicted = xgb_pred)

ggplot(results, aes(x = Date)) +
  geom_line(aes(y = Actual, color = "Actual")) +
  geom_line(aes(y = LM_Predicted, color = "Linear Regression")) +
  geom_line(aes(y = XGB_Predicted, color = "XGBoost")) +
  labs(title = "Bike Rentals: Actual vs Predicted", y = "Count", color = "Legend") +
  theme_minimal()
