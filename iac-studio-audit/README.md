# iAC Studio — Live Website Audit (Demo)

A real-time data analysis report for **iac-studio.com**, built in R Markdown.
Every metric is fetched **live** when the report is rendered — nothing is hard-coded.

## What it analyses

| Section | Live data source |
|---|---|
| Lighthouse scores (Mobile + Desktop) | Google PageSpeed Insights API |
| Core Web Vitals (LCP, TBT, CLS, FCP, SI) | Google PageSpeed Insights API |
| On-page SEO (title, meta, OG, canonical) | `rvest` HTML scrape |
| Heading structure (H1–H6) | `rvest` HTML scrape |
| Content & link profile | `rvest` HTML scrape |
| Security headers | HTTP response headers |
| Tech stack fingerprint | Page source pattern matching |
| Multi-page comparison | Live scrape of multiple URLs |
| Prioritized recommendations | Generated from the metrics above |

## How to run

From the project root in RStudio (or the R console):

```r
# 1. Install dependencies (only first time)
source("iac-studio-audit/setup.R")

# 2. Render the report to HTML
rmarkdown::render("iac-studio-audit/iac_studio_audit.Rmd")
```

Open `iac_studio_audit.html` in a browser to view the report.

## Configuration

All targets live at the top of the Rmd, in the `setup` chunk:

```r
TARGET_URL  <- "https://iac-studio.com/"
EXTRA_PAGES <- c("https://iac-studio.com/our-services/")
```

To audit other pages, add URLs to `EXTRA_PAGES`.

## Notes

- The PageSpeed Insights API works without an API key for low volume use; if you
  hit a rate limit, register for a free key at
  https://developers.google.com/speed/docs/insights/v5/get-started and append
  `&key=YOUR_KEY` inside `fetch_psi()`.
- Re-rendering takes ~30–90 seconds depending on Google's response time.
