library(jsonlite)
library(ggplot2)
library(plotly)

base_url <- "https://www.alphavantage.co"
url <- paste0(base_url, "/query")

symbol <- "GOOG"
query = list(
  "function" = "TIME_SERIES_DAILY",
  symbol = symbol,
  apikey = ""
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
data <- r$`Time Series (Daily)`

df <- data.frame(
  list(
    unlist(Map(function(x) x, names(data)), use.names = FALSE),
    unlist(Map(function(x) as.integer(x[5]), data), use.names = FALSE)
  )
)
names(df) <- c("date", "volume")

fig <- plot_ly(
  df,
  x = ~date,
  y = ~volume,
  type = "scatter",
  mode = "lines"
)

fig <- fig %>% layout(
  title = "Volume",
  xaxis = list(
    type = "date",
    tickformat = "%B %d"
  )
)
fig
