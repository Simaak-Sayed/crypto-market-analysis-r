# ---------------------------------------------------------------------------
# 03 - Predicting BTC log returns with regression models
# ---------------------------------------------------------------------------
# Builds lagged features from BTC and ETH log returns, splits the data into
# training and test sets, and compares three regression models (simple linear,
# stepwise linear, and Lasso) on RMSE, MAE and R squared.
# ---------------------------------------------------------------------------

library(xts)
library(zoo)
library(tidyverse)
library(caret)
library(glmnet)

# Read the dataset (run from the repository root).
candles <- read.csv("data/crypto-candles.csv")

# Build BTC and ETH log returns.
prices <- NULL
for (pair in c("BTCUSD", "ETHUSD")) {
  temp <- subset(candles, SYMBOL == pair)
  temp$TIMESTAMP <- as.POSIXct(temp$TIMESTAMP, origin = "1970-01-01")
  temp <- temp[order(temp$TIMESTAMP), ]
  temp_xts <- as.xts(temp$CLOSE, order.by = temp$TIMESTAMP)
  prices <- cbind(prices, temp_xts)
}
colnames(prices) <- c("BTCUSD", "ETHUSD")
prices <- na.locf(prices)
prices <- na.locf(prices, fromLast = TRUE)

log_returns <- diff.xts(prices, lag = 1, log = TRUE, na.pad = FALSE)
log_returns_df <- as.data.frame(log_returns)

# Create lagged features.
log_returns_df <- log_returns_df %>%
  mutate(across(everything(), ~ lag(.x, order_by = index(log_returns)),
                .names = "lag_{col}")) %>%
  na.omit()

# Target and predictors.
response_var <- log_returns_df$BTCUSD
predictors <- log_returns_df[, -1]

# 80 / 20 train and test split.
set.seed(123)
train_index <- createDataPartition(response_var, p = 0.8, list = FALSE)
train_data <- predictors[train_index, , drop = FALSE]
test_data <- predictors[-train_index, , drop = FALSE]
train_response <- response_var[train_index]
test_response <- response_var[-train_index]

# Model 1: simple linear regression.
lm_model_1 <- lm(train_response ~ ., data = as.data.frame(train_data))
lm_predictions_1 <- predict(lm_model_1, newdata = as.data.frame(test_data))

# Model 2: stepwise linear regression.
lm_model_2 <- step(lm(train_response ~ 1, data = as.data.frame(train_data)),
                   direction = "both", scope = ~ .)
lm_predictions_2 <- predict(lm_model_2, newdata = as.data.frame(test_data))

# Model 3: Lasso regression with cross-validated lambda.
lasso_model <- glmnet(as.matrix(train_data), train_response, alpha = 1)
lasso_cv <- cv.glmnet(as.matrix(train_data), train_response)
lasso_predictions <- predict(lasso_model, newx = as.matrix(test_data),
                             s = lasso_cv$lambda.min)

# Performance metrics.
performance_metrics <- function(actual, predicted) {
  rmse <- sqrt(mean((actual - predicted)^2))
  mae <- mean(abs(actual - predicted))
  r2 <- ifelse(sd(actual) > 0 && sd(predicted) > 0, cor(actual, predicted)^2, NA)
  data.frame(RMSE = rmse, MAE = mae, R2 = r2)
}

results <- rbind(
  data.frame(Model = "Simple Linear Regression",
             performance_metrics(test_response, lm_predictions_1)),
  data.frame(Model = "Stepwise Linear Regression",
             performance_metrics(test_response, lm_predictions_2)),
  data.frame(Model = "Lasso Regression",
             performance_metrics(test_response, lasso_predictions))
)
print(results)

# Visualise the best model (lowest RMSE).
best_model <- which.min(results$RMSE)
best_model_label <- results[best_model, "Model"]
best_model_predictions <- switch(best_model,
                                 lm_predictions_1, lm_predictions_2, lasso_predictions)

ggplot(data.frame(Actual = test_response, Predictions = best_model_predictions),
       aes(x = Actual, y = Predictions)) +
  geom_point(color = "blue") +
  geom_abline(slope = 1, intercept = 0, color = "red") +
  ggtitle(paste(best_model_label, ": Actual vs Predicted")) +
  xlab("Actual Log Returns") + ylab("Predicted Log Returns")
