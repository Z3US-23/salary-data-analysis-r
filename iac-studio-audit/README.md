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

## If R can't reach the internet at all (most sections show fetch errors)

Step 1 — diagnose what's broken:

```r
source("iac-studio-audit/diagnose.R")
```

That probes Google, the PSI API, iac-studio.com, and the Wayback Machine and
tells you which one(s) failed.

Step 2 — switch to **fully manual mode**. Save four files into the
`iac-studio-audit/` folder, then re-knit. The report auto-detects them.

### File 1 + 2 — Saved HTML pages

For each of `https://iac-studio.com/` and any extra page in `EXTRA_PAGES`:
1. Open the URL in your browser.
2. Press **Ctrl+S** (Cmd+S on Mac).
3. Choose **Webpage, HTML Only** in the format dropdown.
4. Save as `iac-studio.html` in the audit folder. (Only the homepage HTML is
   strictly required — `EXTRA_PAGES` will fail-soft.)

### File 3 + 4 — Saved PageSpeed Insights JSON

The PSI website renders the same data the API returns — and you can save the
underlying JSON straight from your browser:

1. Open https://pagespeed.web.dev/ in Chrome.
2. Open DevTools (**F12**) → **Network** tab → tick **Preserve log**.
3. Run the audit on `https://iac-studio.com/` with **Mobile** selected.
4. In the Network panel filter for `runPagespeed`. Right-click the request →
   **Save all as HAR with content** is overkill — instead click the request,
   open the **Response** tab, click **Copy** ▾ → **Copy response**, then paste
   into a new file called `psi-mobile.json` in the audit folder.
5. Switch the audit to **Desktop**, repeat, save as `psi-desktop.json`.

(If the PageSpeed API works for you but the website fetch doesn't, you can
skip files 3+4 entirely and just save the HTML.)

### Then re-knit

```r
rmarkdown::render("iac-studio-audit/iac_studio_audit.Rmd")
```

Each section automatically picks up whichever data is available — live API,
Wayback, or your saved files.

> Section 4 (security headers) needs a *live* server response, so it'll be
> skipped when running off saved files. That's expected.

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
