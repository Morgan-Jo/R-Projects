# Load libraries
library(quantmod)
library(TTR)
library(PerformanceAnalytics)
library(ggplot2)

# Define stock symbols
stocks <- c("AAPL", "MSFT", "TSLA")

# Download data from Yahoo Finance
getSymbols(stocks, from = "2020-01-01", to = Sys.Date(), src = "yahoo")

# Get Stock data for AAPL, MSFT and TSLA
stock_AAPL_data <- AAPL
stock_MSFT_data <- MSFT
stock_TSLA_data <- TSLA

# Plot adjusted close
chartSeries(stock_AAPL_data, type = "line", subset = "last 6 months", theme = chartTheme("white"))
chartSeries(stock_MSFT_data, type = "line", subset = "last 6 months", theme = chartTheme("white"))
chartSeries(stock_TSLA_data, type = "line", subset = "last 6 months", theme = chartTheme("white"))

# Calculate Daily Returns
daily_returns_AALP <- dailyReturn(Cl(stock_AAPL_data))
daily_returns_MSFT <- dailyReturn(Cl(stock_MSFT_data))
daily_returns_TSLA <- dailyReturn(Cl(stock_TSLA_data))

# Calculate Weekly Returns
weekly_returns_AALP <- weeklyReturn(Cl(stock_AAPL_data))
weekly_returns_MSFT <- weeklyReturn(Cl(stock_MSFT_data))
weekly_returns_TSLA <- weeklyReturn(Cl(stock_TSLA_data))

# Plot Daily Returns
plot(daily_returns_AALP, main = "Daily Returns - AAPL", col = "blue")
plot(daily_returns_MSFT, main = "Daily Returns - MSFT", col = "blue")
plot(daily_returns_TSLA, main = "Daily Returns - TSLA", col = "blue")

# Plot Weekly Returns
plot(weekly_returns_AALP, main = "Weekly Returns - AAPL", col = "blue")
plot(weekly_returns_MSFT, main = "Weekly Returns - MSFT", col = "blue")
plot(weekly_returns_TSLA, main = "Weekly Returns - TSLA", col = "blue")

# Add Moving Averages and Bollinger Bands
#AAPL
stock_AAPL_data$SMA20 <- SMA(Cl(stock_AAPL_data), n = 20)
stock_AAPL_data$SMA50 <- SMA(Cl(stock_AAPL_data), n = 50)
bbands <- BBands(Cl(stock_AAPL_data), n = 20)
#MSFT
stock_MSFT_data$SMA20 <- SMA(Cl(stock_MSFT_data), n = 20)
stock_MSFT_data$SMA50 <- SMA(Cl(stock_MSFT_data), n = 50)
bbands <- BBands(Cl(stock_MSFT_data), n = 20)
#TSLA
stock_TSLA_data$SMA20 <- SMA(Cl(stock_TSLA_data), n = 20)
stock_TSLA_data$SMA50 <- SMA(Cl(stock_TSLA_data), n = 50)
bbands <- BBands(Cl(stock_TSLA_data), n = 20)

# Combine with stock data
#AAPL
stock_AAPL_data$BB_Upper <- bbands$up
stock_AAPL_data$BB_Lower <- bbands$dn
stock_AAPL_data$BB_Middle <- bbands$mavg
#MSFT
stock_MSFT_data$BB_Upper <- bbands$up
stock_MSFT_data$BB_Lower <- bbands$dn
stock_MSFT_data$BB_Middle <- bbands$mavg
#TSLA
stock_TSLA_data$BB_Upper <- bbands$up
stock_TSLA_data$BB_Lower <- bbands$dn
stock_TSLA_data$BB_Middle <- bbands$mavg

# Plot with indicators using quantmod
chartSeries(stock_AAPL_data, theme = chartTheme("white"), TA = c(addSMA(20), addSMA(50), addBBands(n = 20)))
chartSeries(stock_MSFT_data, theme = chartTheme("white"), TA = c(addSMA(20), addSMA(50), addBBands(n = 20)))
chartSeries(stock_TSLA_data, theme = chartTheme("white"), TA = c(addSMA(20), addSMA(50), addBBands(n = 20)))


# Simulate simple strategy: Buy if price < Lower BB, Sell if > Upper BB
#AAPL
signals_AAPL <- ifelse(Cl(stock_AAPL_data) < stock_AAPL_data$BB_Lower, 1,
                  ifelse(Cl(stock_AAPL_data) > stock_AAPL_data$BB_Upper, -1, 0))
returns_AAPL <- dailyReturn(Cl(stock_AAPL_data)) * Lag(signals_AAPL)
#MSFT
signals_MSFT <- ifelse(Cl(stock_MSFT_data) < stock_MSFT_data$BB_Lower, 1,
                  ifelse(Cl(stock_MSFT_data) > stock_MSFT_data$BB_Upper, -1, 0))
returns_MSFT <- dailyReturn(Cl(stock_MSFT_data)) * Lag(signals_MSFT)
#TSLA
signals_TSLA <- ifelse(Cl(stock_TSLA_data) < stock_TSLA_data$BB_Lower, 1,
                  ifelse(Cl(stock_TSLA_data) > stock_TSLA_data$BB_Upper, -1, 0))
returns_TSLA <- dailyReturn(Cl(stock_TSLA_data)) * Lag(signals_TSLA)

# Performance summary
charts.PerformanceSummary(na.omit(returns_AAPL), main = "Bollinger Band Strategy Returns AAPL")
charts.PerformanceSummary(na.omit(returns_MSFT), main = "Bollinger Band Strategy Returns MSFT")
charts.PerformanceSummary(na.omit(returns_TSLA), main = "Bollinger Band Strategy Returns TSLA")

# ggplot2 Visualization of Adjusted Close
#AAPL
df1 <- data.frame(Date = index(stock_AAPL_data), coredata(stock_AAPL_data))
df1_clean <- na.omit(df1)
ggplot(data=df1_clean, aes(x = Date)) +
  geom_line(aes(y = AAPL.Adjusted), color = "steelblue") +
  geom_line(aes(y = SMA20), color = "red", linetype = "dashed") +
  geom_line(aes(y = SMA50), color = "darkgreen", linetype = "dashed") +
  labs(title = "AAPL Price with Moving Averages", y = "Price", x = "")
#MSFT
df2 <- data.frame(Date = index(stock_MSFT_data), coredata(stock_MSFT_data))
df2_clean <- na.omit(df2)
ggplot(data=df2_clean, aes(x = Date)) +
  geom_line(aes(y = MSFT.Adjusted), color = "steelblue") +
  geom_line(aes(y = SMA20), color = "red", linetype = "dashed") +
  geom_line(aes(y = SMA50), color = "darkgreen", linetype = "dashed") +
  labs(title = "MSFT Price with Moving Averages", y = "Price", x = "")
#TSLA
df3 <- data.frame(Date = index(stock_TSLA_data), coredata(stock_TSLA_data))
df3_clean <- na.omit(df3)
ggplot(data=df3_clean, aes(x = Date)) +
  geom_line(aes(y = TSLA.Adjusted), color = "steelblue") +
  geom_line(aes(y = SMA20), color = "red", linetype = "dashed") +
  geom_line(aes(y = SMA50), color = "darkgreen", linetype = "dashed") +
  labs(title = "TSLA Price with Moving Averages", y = "Price", x = "")