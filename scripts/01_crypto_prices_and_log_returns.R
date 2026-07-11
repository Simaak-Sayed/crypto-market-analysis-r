# ---------------------------------------------------------------------------
# 01 - Cryptocurrency prices and log returns
# ---------------------------------------------------------------------------
# Builds a clean price table across every trading pair in the dataset, handles
# missing values, computes log returns, and plots prices and returns for a few
# representative pairs. This is the data-wrangling foundation for the analysis
# in the other scripts.
# ---------------------------------------------------------------------------

library(xts)
library(zoo)

# Read the dataset (run this script from the repository root).
candles <- read.csv("data/crypto-candles.csv")

# Extract the unique trading pairs.
all_pairs <- unique(candles[, "SYMBOL"])

# Build a price table: one column of closing prices per trading pair.
prices <- NULL
for (pair in all_pairs) {
  temp <- subset(candles, SYMBOL == pair)
  temp$TIMESTAMP <- as.POSIXct(temp$TIMESTAMP, origin = "1970-01-01")
  temp <- temp[order(temp$TIMESTAMP), ]
  temp_xts <- as.xts(temp$CLOSE, order.by = temp$TIMESTAMP)
  prices <- cbind(prices, temp_xts)
}
colnames(prices) <- all_pairs

# Peek at the assembled table.
head(prices[, sample(1:ncol(prices), 5)], 10)

# Fill missing values by carrying the last known price forward, then backward.
prices <- na.locf(prices)
prices <- na.locf(prices, fromLast = TRUE)

# Compute log returns.
log_returns <- diff.xts(prices, lag = 1, log = TRUE, na.pad = FALSE)
dim(log_returns)
head(log_returns[, sample(1:ncol(log_returns), 5)], 10)

# --- Closing price plots for representative pairs ---------------------------
plot(prices[, "BTCUSD"], type = "l", lwd = 2, col = "blue",
     main = "Closing Prices for BTCUSD", xlab = "Time", ylab = "Price")
plot(prices[, "ETHUSD"], type = "l", lwd = 2, col = "red",
     main = "Closing Prices for ETHUSD", xlab = "Time", ylab = "Price")
plot(prices[, "XMRUSD"], type = "l", lwd = 2, col = "green",
     main = "Closing Prices for XMRUSD", xlab = "Time", ylab = "Price")
plot(prices[, "IOTBTC"], type = "l", lwd = 2, col = "purple",
     main = "Closing Prices for IOTBTC", xlab = "Time", ylab = "Price")

# --- Log return plots -------------------------------------------------------
plot(log_returns[, "BTCUSD"], type = "l", lwd = 2, col = "blue",
     main = "Log Returns for BTCUSD", xlab = "Time", ylab = "Log Return", las = 1)
plot(log_returns[, "ETHUSD"], type = "l", lwd = 2, col = "red",
     main = "Log Returns for ETHUSD", xlab = "Time", ylab = "Log Return", las = 1)
plot(log_returns[, "XMRUSD"], type = "l", lwd = 2, col = "green",
     main = "Log Returns for XMRUSD", xlab = "Time", ylab = "Log Return", las = 1)
plot(log_returns[, "IOTBTC"], type = "l", lwd = 2, col = "purple",
     main = "Log Returns for IOTBTC", xlab = "Time", ylab = "Log Return", las = 1)
