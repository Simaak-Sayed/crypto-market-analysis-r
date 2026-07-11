# ---------------------------------------------------------------------------
# 02 - Unsupervised learning on cryptocurrency log returns
# ---------------------------------------------------------------------------
# Explores structure in BTC and ETH log returns with a distance-matrix heatmap,
# K-means clustering, hierarchical clustering with a dendrogram, and a
# Self-Organizing Map (SOM).
# ---------------------------------------------------------------------------

library(xts)
library(zoo)
library(tidyverse)
library(factoextra)   # clustering visualisation
library(kohonen)      # self-organizing maps
library(reshape2)     # melting data frames for the heatmap
library(ggplot2)

# Read the dataset (run from the repository root).
candles <- read.csv("data/crypto-candles.csv")

# Build a BTC and ETH price table and compute log returns.
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
log_returns_df <- na.omit(as.data.frame(log_returns))

# --- Distance matrix heatmap (on a sampled subset) --------------------------
log_returns_sample <- log_returns_df[seq(1, nrow(log_returns_df), by = 100), ]
dist_matrix_sample <- dist(scale(log_returns_sample), method = "euclidean")
heatmap_data_melted <- melt(as.matrix(dist_matrix_sample))

ggplot(heatmap_data_melted, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  labs(title = "Distance Matrix Heatmap",
       x = "BTC and ETH Log Returns (Sampled)",
       y = "BTC and ETH Log Returns (Sampled)") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# --- K-means clustering -----------------------------------------------------
set.seed(123)
kmeans_result <- kmeans(scale(log_returns_df), centers = 2)
fviz_cluster(kmeans_result, data = scale(log_returns_df),
             geom = "point", ellipse.type = "convex", ellipse.alpha = 0.2,
             pointsize = 3, show.clust.cent = TRUE,
             main = "K-means Clustering of BTCUSD and ETHUSD",
             xlab = "Log Returns of BTCUSD", ylab = "Log Returns of ETHUSD",
             ggtheme = theme_minimal())

# --- Hierarchical clustering ------------------------------------------------
hclust_result <- hclust(dist_matrix_sample, method = "ward.D2")
plot(hclust_result, main = "Dendrogram of BTCUSD and ETHUSD Log Returns",
     xlab = "", sub = "")
rect.hclust(hclust_result, k = 2, border = "red")

# --- Self-Organizing Map (SOM) ----------------------------------------------
som_grid <- somgrid(xdim = 5, ydim = 5, topo = "hexagonal")
log_returns_matrix <- as.matrix(log_returns_df)

set.seed(123)
som_model <- som(log_returns_matrix, grid = som_grid,
                 rlen = 2000, alpha = c(0.05, 0.01), keep.data = TRUE)

som_clusters <- kmeans(som_model$codes[[1]], centers = 2)$cluster
plot(som_model, type = "mapping",
     bgcol = topo.colors(2)[som_clusters],
     main = "SOM Clustering: BTCUSD vs ETHUSD")
add.cluster.boundaries(som_model, som_clusters)
