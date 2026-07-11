# ---------------------------------------------------------------------------
# 04 - Net Present Value and discounted cash flow analysis
# ---------------------------------------------------------------------------
# A small financial-modelling exercise: given a projected cash flow, compute the
# present value of each year's return, the total NPV at a chosen discount rate,
# and the internal rate of return (the rate at which NPV crosses zero).
# ---------------------------------------------------------------------------

# Projected cash flow (values in billions).
cashflow <- data.frame(
  year = 2024:2029,
  outflow = c(30, 20, 10, 5, 5, 5),
  inflow = c(0, 5, 5, 10, 30, 40)
)

# Add net return, discount factors and present values for a given rate.
analyse_cf <- function(cf, rate) {
  cf$return <- cf$inflow - cf$outflow
  cf$n <- cf$year - cf$year[1]
  cf$pvf <- (1 + rate)^(-cf$n)
  cf$pvreturn <- cf$return * cf$pvf
  cf
}

# Total NPV at a given rate.
npv <- function(cf, rate) {
  sum(analyse_cf(cf, rate)$pvreturn)
}

rate <- 0.03
cashflow_table <- analyse_cf(cashflow, rate)

print("Detailed cash flow table:")
print(cashflow_table)
cat("Total Net Present Value at", rate * 100, "percent discount rate: ",
    round(sum(cashflow_table$pvreturn), 2), "B\n")

# NPV across a range of discount rates, and the approximate break-even rate.
rates <- seq(0, 0.3, by = 0.01)
npv_values <- sapply(rates, function(r) npv(cashflow, r))

plot(rates, npv_values, type = "l", col = "blue", lwd = 2,
     xlab = "Discount Rate", ylab = "Net Present Value",
     main = "NPV vs Discount Rate")
abline(h = 0, col = "red", lty = 2)

zero_npv_rate <- rates[which.min(abs(npv_values))]
text(zero_npv_rate, 0,
     labels = paste0("NPV = 0 at ", round(zero_npv_rate * 100, 2), "%"),
     pos = 4, col = "darkgreen")
