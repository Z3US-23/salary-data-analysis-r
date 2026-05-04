# Diagnostic script — run this in the R Console:
#   source("iac-studio-audit/diagnose.R")
# It checks whether your R session can reach the outside world.

cat("=== R Network Diagnostic ===\n\n")
cat("R version:        ", R.version.string, "\n")
cat("OS:               ", Sys.info()[["sysname"]], Sys.info()[["release"]], "\n")
cat("HTTP proxy env:   ", Sys.getenv("http_proxy",  "<none>"), "\n")
cat("HTTPS proxy env:  ", Sys.getenv("https_proxy", "<none>"), "\n\n")

if (!requireNamespace("httr", quietly = TRUE)) {
  install.packages("httr")
}
suppressMessages(library(httr))

probe <- function(label, url) {
  cat(sprintf("Probing %-25s -> ", label))
  res <- tryCatch(
    GET(url, timeout(20)),
    error = function(e) e
  )
  if (inherits(res, "error")) {
    cat("FAIL  (", res$message, ")\n", sep = "")
    return(invisible(FALSE))
  }
  cat(sprintf("HTTP %d  (%s bytes)\n",
              status_code(res),
              format(length(content(res, as = "raw")), big.mark = ",")))
  invisible(TRUE)
}

ok1 <- probe("Google (general internet)", "https://www.google.com/")
ok2 <- probe("PageSpeed Insights API",
             "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=https%3A%2F%2Fexample.com&strategy=mobile")
ok3 <- probe("iac-studio.com",            "https://iac-studio.com/")
ok4 <- probe("Wayback Machine",           "https://archive.org/wayback/available?url=iac-studio.com")

cat("\n=== Verdict ===\n")
if (ok1 && ok2 && ok3 && ok4) {
  cat("All probes OK. The Rmd should work — re-knit it.\n")
} else if (!ok1) {
  cat("R cannot reach the public internet at all.\n",
      "  - Check your internet works in a browser.\n",
      "  - Check Sys.getenv('http_proxy') above — set it if your network uses a proxy:\n",
      "      Sys.setenv(http_proxy='http://YOUR_PROXY:PORT', https_proxy='http://YOUR_PROXY:PORT')\n",
      "  - Try updating curl: install.packages('curl')\n", sep = "")
} else if (!ok3) {
  cat("Internet works but iac-studio.com is blocking R.\n",
      "  -> Use the MANUAL FALLBACK described in iac-studio-audit/README.md\n", sep = "")
} else {
  cat("Mixed results — see which probe failed above.\n")
}
