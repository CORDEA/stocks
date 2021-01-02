library(jsonlite)
library(ggplot2)
library(plotly)

base_url <- "https://api.marketstack.com"
url <- paste0(base_url, "/v1/eod/latest")

symbols = c("GOOG", "AMZN", "FB", "AAPL")
query = list(
  token = "",
  symbols = paste(symbols, collapse = ","),
  from = "",
  to = ""
)

join <- function(a, b) {
  q <- paste(b, query[[b]], sep = "=")
  if (grepl("?", a, fixed = TRUE)) {
    paste(a, q, sep = "&")
  } else {
    paste(a, q, sep = "?")
  }
}
url <- Reduce(join, names(query), url)

r <- fromJSON(url)
data <- r$data

as_date <- function(d) as.Date(d)
data$date <- lapply(data$date, as_date)
data

fig <- plot_ly(
  x = ~date,
  # transforms = list(
  #   list(
  #     type = 'groupby',
  #     groups = ~symbol
  #   )
  # )
)

for (symbol in symbols) {
  fig <- fig %>% add_lines(
    data = data[data$symbol == symbol,],
    y = ~volume,
    name = symbol
  )
}

fig <- fig %>% layout(title = "Volume")
fig
