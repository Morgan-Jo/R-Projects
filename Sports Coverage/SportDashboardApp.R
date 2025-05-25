# Load libraries
library(shiny)
library(tidyverse)
library(wordcloud)
library(tm)
library(RColorBrewer)

# Load the data
sports_data <- read.csv("bbcsports.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Sports Coverage Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("sport", "Select a Sport:", choices = unique(sports_data$label)),
      sliderInput("maxWords", "Max Words in Word Cloud:", min = 10, max = 100, value = 50)
    ),
    
    mainPanel(
      plotOutput("barPlot"),
      plotOutput("wordCloud")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Reactive filtered data
  filtered_data <- reactive({
    sports_data %>% filter(label == input$sport)
  })
  
  # Bar plot: Article counts by sport
  output$barPlot <- renderPlot({
    sports_data %>%
      count(label) %>%
      ggplot(aes(x = reorder(label, -n), y = n, fill = label)) +
      geom_bar(stat = "identity") +
      theme_minimal() +
      labs(title = "Article Count by Sport", x = "Sport", y = "Number of Articles") +
      theme(legend.position = "none")
  })
  
  # Word cloud for selected sport
  output$wordCloud <- renderPlot({
    texts <- filtered_data()$text
    
    # Text processing
    corpus <- Corpus(VectorSource(texts))
    corpus <- corpus %>%
      tm_map(content_transformer(tolower)) %>%
      tm_map(removePunctuation) %>%
      tm_map(removeNumbers) %>%
      tm_map(removeWords, stopwords("english")) %>%
      tm_map(stripWhitespace)
    
    dtm <- TermDocumentMatrix(corpus)
    matrix <- as.matrix(dtm)
    word_freq <- sort(rowSums(matrix), decreasing = TRUE)
    df <- data.frame(word = names(word_freq), freq = word_freq)
    
    # Word cloud
    wordcloud(
      words = df$word, freq = df$freq,
      max.words = input$maxWords,
      colors = brewer.pal(8, "Dark2")
    )
  })
}

# Run the app
shinyApp(ui = ui, server = server)
