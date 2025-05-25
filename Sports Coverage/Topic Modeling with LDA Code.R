# Load libraries
library(tidyverse)
library(tm)
library(tidytext)
library(topicmodels)
library(SnowballC)
library(scales)

# Load data
sports_data <- read.csv("bbcsports.csv", stringsAsFactors = FALSE)

# Create and clean a corpus
corpus <- Corpus(VectorSource(sports_data$text))
corpus <- corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace) %>%
  tm_map(stemDocument)

# Create Document-Term Matrix
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99)  # Optional: remove sparse terms

# Fit LDA model
num_topics <- 5  # You can change this
lda_model <- LDA(dtm, k = num_topics, control = list(seed = 123))

# Extract top terms per topic
topics <- tidy(lda_model, matrix = "beta")  # Tidy format

# Top terms per topic
top_terms <- topics %>%
  group_by(topic) %>%
  slice_max(beta, n = 10) %>%
  ungroup() %>%
  arrange(topic, -beta)

# Visualize top terms per topic
library(ggplot2)
top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(x = beta, y = term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ topic, scales = "free") +
  scale_y_reordered() +
  labs(title = "Top Terms by LDA Topic", x = "Beta (Term Probability)", y = "Term")

