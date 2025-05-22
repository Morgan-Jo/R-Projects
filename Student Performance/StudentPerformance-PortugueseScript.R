# Load libraries
library(tidyverse)
library(caret)
library(corrr)
library(ggplot2)

# Load Portuguese student performance dataset
df <- read.csv("student-por.csv", sep = ";")

# Summary and structure
summary(df)
str(df)

# Final grade distribution
ggplot(df, aes(x = G3)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Distribution of Final Grades (G3)", x = "Final Grade", y = "Count")

# Correlation matrix with G3
numeric_df <- df %>% select_if(is.numeric)
cor_matrix <- correlate(numeric_df)
cor_matrix %>% focus(G3) %>% arrange(desc(abs(G3)))

# Study time vs G3
ggplot(df, aes(x = factor(studytime), y = G3)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Study Time vs Final Grade", x = "Study Time (1-4)", y = "Final Grade")

# Absences vs G3
ggplot(df, aes(x = absences, y = G3)) +
  geom_point(alpha = 0.5, color = "tomato") +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Absences vs Final Grade", x = "Absences", y = "Final Grade")

# Select relevant features
model_data <- df %>%
  select(G3, studytime, absences, failures, Medu, Fedu)

# Linear model feature importance
set.seed(42)
lm_model <- train(G3 ~ ., data = model_data, method = "lm")
varImp(lm_model)

# Split into training and test sets
set.seed(123)
trainIndex <- createDataPartition(df$G3, p = 0.8, list = FALSE)
train_data <- df[trainIndex, ]
test_data <- df[-trainIndex, ]

# Build linear regression model
lm_model <- train(G3 ~ studytime + absences + failures + Medu + Fedu, data = train_data, method = "lm")

# Predict and evaluate
predictions <- predict(lm_model, newdata = test_data)
postResample(predictions, test_data$G3)

# Create binary label
df$pass <- as.factor(ifelse(df$G3 >= 10, "yes", "no"))

# Train logistic regression model
log_model <- train(pass ~ studytime + absences + failures + Medu + Fedu,
                   data = df, method = "glm", family = "binomial")

# Predict and evaluate
preds <- predict(log_model, newdata = df)
confusionMatrix(preds, df$pass)

