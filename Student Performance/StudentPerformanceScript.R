# Load libraries
library(tidyverse)
library(caret)
library(corrr)
library(ggplot2)
library(gridExtra)

# Load datasets
math <- read.csv("student-mat.csv", sep = ";")
por <- read.csv("student-por.csv", sep = ";")

# Add subject label
math$subject <- "Math"
por$subject <- "Portuguese"

# Combine datasets
df <- bind_rows(math, por)

# Summary: Count by subject
table(df$subject)

# ---------------------------------------------
# 1. Compare Distributions: G3 by Subject
# ---------------------------------------------
ggplot(df, aes(x = G3, fill = subject)) +
  geom_histogram(binwidth = 1, position = "dodge", color = "white") +
  labs(title = "Final Grades Distribution by Subject", x = "G3 (Final Grade)", y = "Count")

# Study time comparison
ggplot(df, aes(x = factor(studytime), fill = subject)) +
  geom_bar(position = "dodge") +
  labs(title = "Study Time by Subject", x = "Study Time Level", y = "Number of Students")

# Absences comparison
ggplot(df, aes(x = absences, fill = subject)) +
  geom_histogram(position = "identity", alpha = 0.5, binwidth = 2) +
  labs(title = "Absences Distribution by Subject", x = "Absences", y = "Count")

# ---------------------------------------------
# 2. Correlation and Feature Importance by Subject
# ---------------------------------------------
# Split into math and portuguese again
math_data <- df %>% filter(subject == "Math")
por_data <- df %>% filter(subject == "Portuguese")

# Correlation matrices
math_cor <- correlate(select_if(math_data, is.numeric))
por_cor <- correlate(select_if(por_data, is.numeric))

# Correlation with G3
math_cor %>% focus(G3) %>% arrange(desc(abs(G3)))
por_cor %>% focus(G3) %>% arrange(desc(abs(G3)))

# ---------------------------------------------
# 3. Linear Regression Comparison
# ---------------------------------------------
# Prepare formula and features
features <- c("studytime", "absences", "failures", "Medu", "Fedu")
formula <- as.formula(paste("G3 ~", paste(features, collapse = " + ")))

# Train/test split function
split_data <- function(data) {
  set.seed(123)
  idx <- createDataPartition(data$G3, p = 0.8, list = FALSE)
  list(train = data[idx, ], test = data[-idx, ])
}

math_split <- split_data(math_data)
por_split <- split_data(por_data)

# Train models
lm_math <- train(formula, data = math_split$train, method = "lm")
lm_por <- train(formula, data = por_split$train, method = "lm")

# Evaluate models
res_math <- postResample(predict(lm_math, math_split$test), math_split$test$G3)
res_por <- postResample(predict(lm_por, por_split$test), por_split$test$G3)

# Show results
print("Math Linear Regression Performance:")
print(res_math)

print("Portuguese Linear Regression Performance:")
print(res_por)

# ---------------------------------------------
# 4. Logistic Regression: Predict Pass/Fail
# ---------------------------------------------
# Add pass/fail label to math and Portuguese datasets
math_data$pass <- as.factor(ifelse(math_data$G3 >= 10, "yes", "no"))
por_data$pass  <- as.factor(ifelse(por_data$G3 >= 10, "yes", "no"))

df$pass <- as.factor(ifelse(df$G3 >= 10, "yes", "no"))

# Logistic model per subject
log_math <- train(pass ~ studytime + absences + failures + Medu + Fedu,
                  data = math_data, method = "glm", family = "binomial")

log_por <- train(pass ~ studytime + absences + failures + Medu + Fedu,
                 data = por_data, method = "glm", family = "binomial")

# Confusion matrices
pred_math <- predict(log_math, math_data)
pred_por <- predict(log_por, por_data)

confusionMatrix(pred_math, math_data$pass)
confusionMatrix(pred_por, por_data$pass)
