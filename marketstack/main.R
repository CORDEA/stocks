library(jsonlite)

base_url <- "https://api.marketstack.com"
url <- paste(base_url, "/v1/eod/latest", sep = "")

query = list(
  token = "",
  symbols = "",
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
