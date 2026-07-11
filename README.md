# Cryptocurrency Market Analysis in R

An R project exploring cryptocurrency market data end to end, from raw exchange candles to unsupervised structure discovery, predictive modelling, and financial valuation. It covers time-series data wrangling, clustering, dimensionality-aware visualisation, regression modelling, and discounted cash flow analysis.

![R](https://img.shields.io/badge/R-data%20analysis-276DC3)
![Unsupervised](https://img.shields.io/badge/ML-clustering%20%2B%20SOM-success)
![Regression](https://img.shields.io/badge/ML-linear%20%2F%20lasso-orange)

---

## What this project does

I start from raw exchange candle data (open, high, low, close, volume per trading pair) and work through four connected pieces of analysis.

1. **Data wrangling and log returns.** I build a tidy price table across every trading pair, align it on time, handle missing values by forward and backward filling, and compute log returns as the basis for everything downstream.
2. **Unsupervised learning.** I look for structure in the returns with a distance-matrix heatmap, K-means clustering, hierarchical clustering with a dendrogram, and a Self-Organizing Map.
3. **Predictive modelling.** I build lagged features and compare three regression models (simple linear, stepwise linear, and Lasso) on a proper train and test split, scored on RMSE, MAE, and R squared.
4. **Financial valuation.** I implement a discounted cash flow model that computes present values, total Net Present Value at a chosen discount rate, and the break-even rate where NPV crosses zero.

---

## Skills demonstrated

- **Data wrangling in R**: `xts`, `zoo`, `tidyverse`, time alignment, missing-value handling, feature engineering with lags
- **Unsupervised learning**: K-means, hierarchical clustering, dendrograms, Self-Organizing Maps (`kohonen`), distance matrices
- **Supervised learning**: linear regression, stepwise selection, Lasso with cross-validated lambda (`glmnet`, `caret`)
- **Model evaluation**: train and test splitting, RMSE, MAE, R squared, actual versus predicted plots
- **Visualisation**: `ggplot2`, heatmaps, cluster plots, financial charts
- **Financial modelling**: log returns, discounted cash flow, Net Present Value, break-even analysis

---

## Repository structure

```
crypto-market-analysis-r/
├── data/
│   ├── crypto-candles.csv     # raw exchange candles (multiple trading pairs)
│   └── ev-data.csv            # supporting dataset
├── scripts/
│   ├── 01_crypto_prices_and_log_returns.R    # price table, missing values, log returns, plots
│   ├── 02_unsupervised_clustering_som.R      # heatmap, K-means, hierarchical, SOM
│   ├── 03_return_prediction_regression.R     # lagged features, linear/stepwise/Lasso
│   └── 04_npv_discounted_cashflow.R          # NPV and break-even analysis
└── README.md
```

---

## How to run

Open the project in R or RStudio from the repository root, then run the scripts in order. Install the packages once beforehand:

```r
install.packages(c("xts", "zoo", "tidyverse", "factoextra", "kohonen",
                   "reshape2", "ggplot2", "caret", "glmnet"))

source("scripts/01_crypto_prices_and_log_returns.R")
source("scripts/02_unsupervised_clustering_som.R")
source("scripts/03_return_prediction_regression.R")
source("scripts/04_npv_discounted_cashflow.R")
```

Each script reads its data with a relative path, so it runs as long as your working directory is the repository root.

---

## Notes

The market data here is historical and this project is for analysis and learning. Nothing in it is financial advice.
