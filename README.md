# 📁 R Data Science Projects

This repository showcases data science projects built in **R**, focusing on data exploration, visualization, and predictive modeling. Each project uses real-world datasets and demonstrates practical applications of R packages and tools.
There is aslo R coding projects from online course. 

---

## CodeClan Workshop 
  A data analysis workshop that was instructor leaded on **R**. 

---

## Dissertation
## 📊 Drug Mortality Trends in Scotland (2008–2020)
### Overview
This **R** project analyzes the rising trends in drug-induced mortality across Scotland from 2008 to 2020. By modeling the relationship between specific drugs and mortality rates, we aim to identify which substances—legal or illegal—are driving the most significant increases in fatalities.

### Objectives
- Construct and evaluate linear and nonlinear regression models to describe temporal trends.
- Determine which drugs have shown the steepest rise in mortality over the 12-year period.
- Compare the effects of legal (e.g., prescription drugs, alcohol) vs. illegal drugs (e.g., heroin, codeine) on mortality.

### Methodology
- Conducted a literature review to understand existing research.
- Cleaned and organized publicly available mortality data.
- Applied statistical modeling in R using packages such as nlstools and ggplot2.
- Evaluated models based on goodness-of-fit and interpretability.
- Interpreted results to draw policy-relevant conclusions.

### Tools & Packages
- `ggplot2` – for data visualization
- `nlme` – for fitting and analyzing linear and nonlinear mixed-effects models
- `dplyr`, `tidyr` – for data wrangling

### Data Scource
Drug-related deaths in Scotland in 2020 from National Records of Scotland

---

## 📈 1. Stock Price Analysis

### Overview
A financial analysis project using historical stock price data from companies like Apple, Microsoft, and Tesla. It explores return trends, volatility, and basic technical indicators.

### Objectives
- Download and visualize stock prices using `quantmod`
- Calculate daily and weekly returns
- Apply moving averages and Bollinger Bands
- Simulate basic trading strategies

### Tools & Libraries
- `quantmod`
- `TTR`
- `PerformanceAnalytics`
- `ggplot2`

### Data Source
- Yahoo Finance via `quantmod::getSymbols()`

---

## 🍷 2. Wine Quality Prediction

### Overview
Use machine learning to predict wine quality based on physicochemical properties. The dataset includes ratings for red and white wines.

### Objectives
- Perform EDA and correlation analysis
- Build regression and classification models (linear regression, random forest)
- Evaluate model accuracy and feature importance
- Visualize relationships between variables

### Tools & Libraries
- `caret`
- `randomForest`
- `ggplot2`
- `corrplot`

### Data Source
- [UCI Wine Quality Dataset](https://archive.ics.uci.edu/ml/datasets/wine+quality)

---

## 🎓 3. Student Performance Analysis 

### Overview
Analyze student performance data to understand factors influencing academic achievement and predict final grades.

### Objectives
- Analyze the effect of study time, parental involvement, and absences on grades
- Build linear and logistic regression models
- Identify key predictors using feature importance
- Visualize correlations and trends

### Tools & Libraries
- `tidyverse`
- `caret`
- `ggplot2`
- `corrr`

### Data Source
- [Student Performance Dataset - UCI](https://archive.ics.uci.edu/ml/datasets/Student+Performance)

---

## 🚲 4. Bike Sharing Demand Forecasting

### Overview
Forecast bike rental demand based on weather, season, and time factors using regression models.

### Objectives
- Time series analysis and decomposition
- Feature engineering from datetime variables
- Build and compare ML models for prediction
- Evaluate model performance using RMSE

### Tools & Libraries
- `caret`
- `xgboost`
- `ggplot2`
- `lubridate`
- `shiny`

### Data Source
- [Bike Sharing Dataset - UCI](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset)

---

## 🌱 5. World Happiness Report Analysis

### Overview
Explore global happiness trends and understand which socio-economic indicators influence happiness scores across countries.

### Objectives
- Rank countries by happiness and visualize geographic distribution
- Analyze correlations between happiness score and GDP, freedom, and health
- Create interactive maps and trend plots

### Tools & Libraries
- `tidyverse`
- `ggplot2`
- `leaflet`
- `corrplot`

### Data Source
- [World Happiness Report on Kaggle](https://www.kaggle.com/datasets/unsdsn/world-happiness)

---

## 6. 📰 Sports Article Text Analysis and Interactive Dashboard

This repository presents an end-to-end project that explores sports articles from the BBC dataset using R. It includes a Shiny Dashboard for interactive exploration, as well as text mining and topic modeling for deeper analysis of themes and keyword patterns.

### a. Sports Coverage Dashboard (Shiny App)

An interactive Shiny app built to:
- Display the number of articles per sport (bar chart)
- Generate a word cloud for a selected sport
- Allow dynamic filtering and word limit adjustment

### Features

- Sidebar for sport selection and word cloud configuration
- Bar chart for overall article count by sport
- Word cloud dynamically generated per selected sport

### b. Text Mining & Word Cloud (Static Analysis)

This script cleans and processes article text and produces a frequency-based word cloud.

### Cleaning Steps:

- Lowercasing, punctuation and stopword removal
- Tokenization and frequency computation
- Word cloud visualization of most common words

### c. Topic Modeling with LDA

Performs unsupervised topic modeling using **Latent Dirichlet Allocation (LDA)** to identify dominant themes across the articles.

### Workflow:

- Preprocess text using stemming and cleaning
- Create a document-term matrix
- Apply LDA with `topicmodels::LDA`
- Visualize top 10 terms per topic using `ggplot2`

### Sample Topics Found:

- Player injuries and match fitness
- Team transfers and contracts
- Scoreline summaries and game outcomes

### Tools & Libraries

- `shiny`
- `tm`
- `tidyverse`
- `wordcloud`
- `RColorBrewer`
- `topicmodels`
- `SnowballC`
- `ggplot2`

### Data Source
- bbcsports

---

## 🚀 Getting Started
Each project contains:
- Raw or downloadable datasets
- R scripts (`.R`) or notebooks (`.Rmd`)
- Output visualizations and reports

Clone the repo and open `.Rproj` to explore the analyses.

---

## 📌 Author
Morgan Tonner  

📈 Data-driven and passionate about open analytics, education, and applied machine learning
