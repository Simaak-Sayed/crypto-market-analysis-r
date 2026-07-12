# Cryptocurrency Market Analysis in R

An R project that explores cryptocurrency market data end to end, from raw exchange candles to unsupervised structure discovery, predictive modelling, and financial valuation. It covers time-series data wrangling, clustering, self-organizing maps, regression modelling with proper evaluation, and discounted cash flow analysis, all as runnable, well-commented scripts.

![R](https://img.shields.io/badge/R-data%20analysis-276DC3)
![Unsupervised](https://img.shields.io/badge/ML-clustering%20%2B%20SOM-success)
![Regression](https://img.shields.io/badge/ML-linear%20%2F%20lasso-orange)
![Finance](https://img.shields.io/badge/Finance-log%20returns%20%2F%20NPV-4479a1)

---

## Table of contents

1. [Overview](#overview)
2. [The four analyses](#the-four-analyses)
3. [Methods and techniques](#methods-and-techniques)
4. [Skills demonstrated](#skills-demonstrated)
5. [Datasets](#datasets)
6. [Repository structure](#repository-structure)
7. [How to run](#how-to-run)
8. [Notes](#notes)

---

## Overview

I start from raw exchange candle data (open, high, low, close, and volume for each trading pair) and work through four connected pieces of analysis. The first script prepares the data and computes log returns, which become the foundation for the unsupervised and predictive work that follows. Each script reads its data with a relative path and is commented step by step, so the whole project runs from the repository root without any changes.

---

## The four analyses

### 1. Data wrangling and log returns
`scripts/01_crypto_prices_and_log_returns.R`

Builds a tidy price table across every trading pair in the dataset. It parses timestamps into proper date-time objects, orders each series in time, converts the closing prices into an `xts` time-series object, and combines them into a single price table. Missing values are handled by carrying the last known price forward and then backward, and the script computes log returns from the aligned prices. It finishes by plotting closing prices and log returns for a set of representative pairs such as BTC, ETH, XMR, and IOT.

### 2. Unsupervised learning
`scripts/02_unsupervised_clustering_som.R`

Looks for structure in the BTC and ETH log returns using four techniques in sequence: a distance-matrix heatmap on a sampled subset, K-means clustering with a cluster plot, hierarchical clustering with a dendrogram and cut boundaries, and a Self-Organizing Map trained on the returns and then coloured by a K-means split of its nodes.

### 3. Predictive modelling
`scripts/03_return_prediction_regression.R`

Builds lagged features from the log returns, splits the data into training and test sets while preserving order, and compares three regression models: a simple linear model, a stepwise linear model chosen by both-direction selection, and a Lasso model with a cross-validated penalty. Each model is scored on RMSE, MAE, and R squared on the held-out test set, and the best model by RMSE is plotted as actual versus predicted.

### 4. Financial valuation
`scripts/04_npv_discounted_cashflow.R`

A discounted cash flow model. Given a projected cash flow, it computes the present value of each year's net return, the total Net Present Value at a chosen discount rate, and the approximate break-even rate where NPV crosses zero, which it plots against a range of discount rates.

---

## Methods and techniques

| Area | Techniques |
|------|-----------|
| Time-series wrangling | `xts` and `zoo`, timestamp parsing, ordering, forward and backward fill, log returns |
| Unsupervised learning | distance matrices, K-means, hierarchical clustering, dendrograms, Self-Organizing Maps (`kohonen`) |
| Supervised learning | lagged features, train and test split, linear regression, stepwise selection, Lasso (`glmnet`, `caret`) |
| Model evaluation | RMSE, MAE, R squared, actual versus predicted plots |
| Visualisation | `ggplot2`, heatmaps, cluster plots, dendrograms, financial charts |
| Financial modelling | log returns, discounted cash flow, Net Present Value, break-even analysis |

---

## Skills demonstrated

- Data wrangling and feature engineering in R
- Both unsupervised and supervised machine learning in one coherent project
- Sound evaluation practice with a held-out test set and multiple metrics
- Clear, reproducible, and commented scripts that run from relative paths
- Financial reasoning: returns, discounting, and valuation

---

## Datasets

| File | Description |
|------|-------------|
| `data/crypto-candles.csv` | Raw exchange candles for multiple trading pairs (the main dataset). |
| `data/ev-data.csv` | A small supporting dataset. |

---

## Repository structure

```
crypto-market-analysis-r/
├── data/
│   ├── crypto-candles.csv
│   └── ev-data.csv
├── scripts/
│   ├── 01_crypto_prices_and_log_returns.R    # price table, missing values, log returns, plots
│   ├── 02_unsupervised_clustering_som.R      # heatmap, K-means, hierarchical, SOM
│   ├── 03_return_prediction_regression.R     # lagged features, linear/stepwise/Lasso, metrics
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
