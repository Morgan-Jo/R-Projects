# 📁 R Data Science Projects

This repository showcases data science projects built in **R**, focusing on data exploration, visualization, and predictive modeling. Each project uses real-world datasets and demonstrates practical applications of R packages and tools.
There is aslo R coding projects from online course. 

---

## CodeClan Workshop 
  A data analysis workshop. 

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

### Data Source
- [Bike Sharing Dataset - UCI](https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset)

---

## 🌱 5. World Happiness Report Analysis (Coming Soon)

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
