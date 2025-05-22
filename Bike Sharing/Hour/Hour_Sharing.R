# Load libraries
library(tidyverse)
library(lubridate)
library(caret)
library(xgboost)
library(Metrics)

# Load data
data <- read.csv("hour.csv")

# Feature engineering
data$datetime <- ymd(data$dteday) + hours(data$hr)
data$hour <- hour(data$datetime)
data$day <- day(data$datetime)
data$month <- month(data$datetime)
data$wday <- wday(data$datetime, label = TRUE)

# Select features
features <- data %>%
  select(cnt, temp, hum, windspeed, season, holiday, workingday, weathersit, hour, month, wday)

# Train-test split
set.seed(123)
train_idx <- createDataPartition(features$cnt, p = 0.8, list = FALSE)
train_data <- features[train_idx, ]
test_data <- features[-train_idx, ]


# Linear regression model
lm_model <- train(cnt ~ ., data = train_data, method = "lm")
lm_preds <- predict(lm_model, newdata = test_data)

# XGBoost model
xgb_train <- xgb.DMatrix(data = as.matrix(sapply(train_data %>% select(-cnt), as.numeric)), label = train_data$cnt)
xgb_test <- xgb.DMatrix(data = as.matrix(sapply(test_data %>% select(-cnt), as.numeric)))

xgb_model <- xgboost(data = xgb_train, nrounds = 100, objective = "reg:squarederror", verbose = 0)
xgb_preds <- predict(xgb_model, xgb_test)

# Evaluate models
rmse_lm <- rmse(test_data$cnt, lm_preds)
rmse_xgb <- rmse(test_data$cnt, xgb_preds)

# Print RMSE results
print(paste("Linear Regression RMSE:", round(rmse_lm, 2)))
print(paste("XGBoost RMSE:", round(rmse_xgb, 2)))

# Visualization
results <- data.frame(
  Date = test_data$hour,
  Actual = test_data$cnt,
  LM_Predicted = lm_preds,
  XGB_Predicted = xgb_preds
)

results_long <- results %>%
  pivot_longer(cols = c("Actual", "LM_Predicted", "XGB_Predicted"),
               names_to = "Type", values_to = "Count")

ggplot(results_long, aes(x = Date, y = Count, color = Type)) +
  geom_line() +
  labs(title = "Bike Rental Prediction Comparison", x = "Hour", y = "Bike Count")
