library(jsonlite)

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
    unlist(Map(function(x) as.Date(x), names(data)), use.names = FALSE),
    unlist(Map(function(x) x[5], data), use.names = FALSE)
  )
)
names(df) <- c("Date", "Volume")

