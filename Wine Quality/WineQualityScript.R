# Load libraries
library(ggplot2)
library(caret)
library(randomForest)
library(corrplot)
library(dplyr)

# Load datasets
red <- read.csv("winequality-red.csv", sep = ";")
white <- read.csv("winequality-white.csv", sep = ";")

# Add wine type
red$type <- 'red'
white$type <- 'white'

# Combine datasets
wine <- rbind(red, white)

# Convert type to factor
wine$type <- as.factor(wine$type)

# 1. EDA: Summary stats
summary(wine)

# 2. Correlation matrix
cor_matrix <- cor(wine[, 1:11])
corrplot(cor_matrix, method = "color", tl.cex = 0.8)

# 3. Visualize quality distribution
ggplot(wine, aes(x = quality, fill = type)) +
  geom_bar(position = "dodge") +
  labs(title = "Wine Quality Distribution")

# 4. Relationship: Alcohol vs. Quality
ggplot(wine, aes(x = alcohol, y = quality, color = type)) +
  geom_point(alpha = 0.4) +
  geom_smooth(method = "lm") +
  labs(title = "Alcohol vs Quality")

# 5. Prepare data
set.seed(123)
wine$quality <- as.factor(wine$quality)  # Classification
trainIndex <- createDataPartition(wine$quality, p = 0.8, list = FALSE)
train <- wine[trainIndex, ]
test <- wine[-trainIndex, ]

# 6. Random Forest Classifier
rf_model <- randomForest(quality ~ ., data = train[, -which(names(train) == "type")], ntree = 100)
pred_rf <- predict(rf_model, test)

# Confusion Matrix
confusionMatrix(pred_rf, test$quality)

# Feature Importance
importance <- importance(rf_model)
varImpPlot(rf_model, main = "Feature Importance - Random Forest")

# 7. Linear Regression (for regression prediction)
wine$quality <- as.numeric(as.character(wine$quality))

# Train-test split
set.seed(123)
index <- sample(1:nrow(wine), 0.8 * nrow(wine))
train <- wine[index, ]
test <- wine[-index, ]

# Fit Linear Regression Model
lm_model <- lm(quality ~ . -type, data = train)
summary(lm_model)

# Predict and evaluate
lm_pred <- predict(lm_model, test)
rmse <- sqrt(mean((lm_pred - test$quality)^2))
print(paste("RMSE of Linear Regression:", round(rmse, 3)))
