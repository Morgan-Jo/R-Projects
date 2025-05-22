# Load libraries
library(tidyverse)
library(caret)
library(corrr)
library(ggplot2)

# Load math student performance dataset
df <- read.csv("student-mat.csv", sep = ";")

# Summary of the dataset
summary(df)
str(df)

# Distribution of final grades
ggplot(df, aes(x = G3)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "white") +
  labs(title = "Distribution of Final Grades (G3)", x = "Final Grade", y = "Count")

# Correlation with numeric variables
numeric_df <- df %>% select_if(is.numeric)
cor_matrix <- correlate(numeric_df)
cor_matrix %>% focus(G3) %>% arrange(desc(abs(G3)))

# Study Time vs Final Grade
ggplot(df, aes(x = factor(studytime), y = G3)) +
  geom_boxplot(fill = "skyblue") +
  labs(title = "Study Time vs Final Grade", x = "Study Time (1-4)", y = "Final Grade")

# Absences vs Final Grade
ggplot(df, aes(x = absences, y = G3)) +
  geom_point(alpha = 0.5, color = "tomato") +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Absences vs Final Grade", x = "Absences", y = "Final Grade")

# Check variable importance with linear model
model_data <- df %>%
  select(G3, studytime, absences, failures, Medu, Fedu)

set.seed(42)
lm_model <- train(G3 ~ ., data = model_data, method = "lm")
varImp(lm_model)

# Split data
set.seed(123)
trainIndex <- createDataPartition(df$G3, p = 0.8, list = FALSE)
train_data <- df[trainIndex, ]
test_data <- df[-trainIndex, ]

# Model
lm_model <- train(G3 ~ studytime + absences + failures + Medu + Fedu, data = train_data, method = "lm")

# Predict and Evaluate
predictions <- predict(lm_model, newdata = test_data)
postResample(predictions, test_data$G3)

# Create binary outcome
df$pass <- ifelse(df$G3 >= 10, "yes", "no")
df$pass <- as.factor(df$pass)

# Model
log_model <- train(pass ~ studytime + absences + failures + Medu + Fedu,
                   data = df, method = "glm", family = "binomial")

# Confusion Matrix
preds <- predict(log_model, newdata = df)
confusionMatrix(preds, df$pass)


