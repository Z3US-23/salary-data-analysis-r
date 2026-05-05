required_packages <- c(
  "tidyverse",
  "httr",
  "jsonlite",
  "rvest",
  "xml2",
  "knitr",
  "kableExtra",
  "lubridate",
  "stringr",
  "scales"
)

missing <- required_packages[!required_packages %in% installed.packages()[, "Package"]]
if (length(missing) > 0) {
  install.packages(missing, repos = "https://cloud.r-project.org")
}

invisible(lapply(required_packages, library, character.only = TRUE))
cat("All packages loaded.\n")
