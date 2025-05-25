# Load libraries
library(tidyverse)
library(ggplot2)
library(leaflet)
library(corrplot)
library(rworldmap)
library(dplyr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(htmlwidgets)

# Load data
data_2015 <- read.csv("2015.csv")
data_2016 <- read.csv("2016.csv")
data_2017 <- read.csv("2017.csv")
data_2018 <- read.csv("2018.csv")
data_2019 <- read.csv("2019.csv")

# Standardize and clean each dataset
clean_data <- function(df, year) {
  df$Year <- year
  if (year %in% c(2015, 2016)) {
    df <- df %>%
      rename(Country = Country,
             Score = Happiness.Score,
             GDP = Economy..GDP.per.Capita.,
             Social_Support = Family,
             Life_Expectancy = Health..Life.Expectancy.,
             Freedom = Freedom,
             Trust = Trust..Government.Corruption.,
             Generosity = Generosity)
  } else if (year == 2017) {
    df <- df %>%
      rename(Country = Country,
             Score = Happiness.Score,
             GDP = Economy..GDP.per.Capita.,
             Social_Support = Family,
             Life_Expectancy = Health..Life.Expectancy.,
             Freedom = Freedom,
             Trust = Trust..Government.Corruption.,
             Generosity = Generosity)
  } else {
    df <- df %>%
      rename(Country = `Country.or.region`,
             Score = Score,
             GDP = `GDP.per.capita`,
             Social_Support = `Social.support`,
             Life_Expectancy = `Healthy.life.expectancy`,
             Freedom = `Freedom.to.make.life.choices`,
             Trust = `Perceptions.of.corruption`,
             Generosity = Generosity)
  }
  
  df <- df %>%
    mutate(across(c(Score, GDP, Social_Support, Life_Expectancy, Freedom, Trust, Generosity), ~ as.numeric(as.character(.))))
  
  df %>%
    select(Country, Year, Score, GDP, Social_Support, Life_Expectancy, Freedom, Generosity, Trust)
}

# Apply cleaning and combine
df_all <- bind_rows(
  clean_data(data_2015, 2015),
  clean_data(data_2016, 2016),
  clean_data(data_2017, 2017),
  clean_data(data_2018, 2018),
  clean_data(data_2019, 2019)
)

# View sample
head(df_all)

# --------------------
# Visualize Rankings Over Time
# --------------------
top10_2019 <- df_all %>% filter(Year == 2019) %>% top_n(10, Score)

ggplot(top10_2019, aes(x = reorder(Country, Score), y = Score)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  coord_flip() +
  labs(title = "Top 10 Happiest Countries (2019)", x = "", y = "Happiness Score")

# --------------------
# Correlation Matrix
# --------------------
cor_data <- df_all %>% select(Score, GDP, Social_Support, Life_Expectancy, Freedom, Generosity, Trust) %>% na.omit()
corr_matrix <- cor(cor_data)
corrplot(corr_matrix, method = "circle")

# --------------------
# Interactive Map (2019)
# --------------------
map_data <- df_all %>% filter(Year == 2019)

# Merge with world map
joined <- joinCountryData2Map(map_data, joinCode = "NAME", nameJoinColumn = "Country")

mapCountryData(joined, nameColumnToPlot = "Score", mapTitle = "World Happiness Score 2019")

# Leaflet choropleth if lat/long available
# Get world map as simple features (sf) object
world <- ne_countries(scale = "medium", returnclass = "sf")

# Assuming your combined happiness dataframe is `df_all`
happiness_2019 <- df_all %>% filter(Year == 2019)

# Join by country name
world_happiness <- left_join(world, happiness_2019, by = c("name" = "Country"))

# Define color palette
pal <- colorNumeric(palette = "YlGnBu", domain = world_happiness$Score, na.color = "transparent")

# Build leaflet map
leaflet(data = world_happiness) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~pal(Score),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.8,
    highlight = highlightOptions(
      weight = 2,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~paste(name, "<br>", "Happiness Score:", Score),
    labelOptions = labelOptions(direction = "auto")
  ) %>%
  addLegend(pal = pal, values = ~Score, opacity = 0.7, title = "Happiness Score",
            position = "bottomright")


# Store map in an object
happiness_map <- leaflet(world_happiness) %>%
  addTiles() %>%
  addPolygons(
    fillColor = ~pal(Score),
    weight = 1,
    opacity = 1,
    color = "white",
    dashArray = "3",
    fillOpacity = 0.8,
    highlight = highlightOptions(
      weight = 2,
      color = "#666",
      dashArray = "",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~paste(name, "<br>", "Happiness Score:", Score),
    labelOptions = labelOptions(direction = "auto")
  ) %>%
  addLegend(pal = pal, values = ~Score, opacity = 0.7, title = "Happiness Score",
            position = "bottomright")

# Save as HTML file
saveWidget(happiness_map, "happiness_map_2019.html")

