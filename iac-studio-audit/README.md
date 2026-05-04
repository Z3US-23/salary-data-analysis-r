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

## If the site can't be fetched (Section 3 says "could not connect")

The report tries 3 strategies in order before giving up:

1. **Direct fetch** with full browser-style headers (3 attempts, exponential backoff)
2. **Wayback Machine** snapshot fallback (2 attempts) — uses the most recent
   archive.org snapshot if the live site refuses connections
3. **Local file fallback** — load HTML you saved manually

If all three fail you'll see a yellow notice in the report. To use the local
fallback:

1. Open `https://iac-studio.com/` in your browser.
2. Press **Ctrl+S** (or Cmd+S on Mac).
3. Choose **"Webpage, HTML Only"**.
4. Save it as `iac-studio.html` inside the `iac-studio-audit/` folder
   (next to `iac_studio_audit.Rmd`).
5. Re-knit the report. It will load the saved HTML and continue.

> Sections that depend on live response headers (Section 4 — Security headers)
> can only be filled with a live fetch, so they'll be skipped when running off
> a cached/local copy.
