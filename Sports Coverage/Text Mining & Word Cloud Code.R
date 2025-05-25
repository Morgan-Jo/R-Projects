# Load libraries
library(tidyverse)
library(tm)
library(tidytext)
library(wordcloud)
library(RColorBrewer)

# Load data
sports_data <- read.csv("bbcsports.csv", stringsAsFactors = FALSE)

# Combine all text into a single corpus
text_corpus <- Corpus(VectorSource(sports_data$text))

# Clean text
clean_corpus <- text_corpus %>%
  tm_map(content_transformer(tolower)) %>%
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(removeWords, stopwords("english")) %>%
  tm_map(stripWhitespace)

# Create Document-Term Matrix
dtm <- DocumentTermMatrix(clean_corpus)

# Convert to matrix and compute word frequencies
dtm_matrix <- as.matrix(dtm)
word_freq <- sort(colSums(dtm_matrix), decreasing = TRUE)
word_df <- data.frame(word = names(word_freq), freq = word_freq)

# Show top words
head(word_df, 10)

# Create word cloud
set.seed(123)
wordcloud(
  words = word_df$word,
  freq = word_df$freq,
  min.freq = 3,
  max.words = 100,
  random.order = FALSE,
  colors = brewer.pal(8, "Dark2")
)
