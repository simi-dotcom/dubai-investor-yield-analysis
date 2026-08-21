# Dubai Buy-to-Let Investor Marketing Analysis

**A linguist's data project — applying structured business analysis to Dubai real estate listing data to answer one question: where should a real estate agency spend its investor-marketing budget?**

---

## 1. Business Problem

Dubai real estate agencies run paid campaigns, landing pages, and investor webinars to attract buy-to-let buyers — people purchasing property specifically to rent it out for income. Marketing budget is finite, and Dubai has 60+ distinct communities to choose from. Spending equally across all of them wastes budget on areas that don't deliver rental income relative to their price. **Which communities and property types should get priority marketing spend, and which should be deprioritized?**

## 2. Core Message

Rental yield — annual rent as a percentage of purchase price — varies by more than **2x** across Dubai communities (10.14% in Jebel Ali vs. 4.59% in The Meadows), and the pattern is consistent: **affordable apartments in emerging communities outyield premium villas by a wide margin.** This is a clear, data-backed segmentation an agency can act on immediately.

## 3. The Decision

**Prioritize buy-to-let investor-marketing spend on affordable-to-mid-priced apartment communities with strong, consistent yield (JVC, Dubai Production City, Discovery Gardens, Dubai Sports City) — and deprioritize premium villa communities (The Meadows, Jumeirah Islands, Arabian Ranches) for yield-focused campaigns.** Premium villa communities aren't bad investments — they're simply a different pitch (capital appreciation, lifestyle), and shouldn't be marketed with a rental-yield message that the data doesn't support.

## 4. North Star Metric

**Average rental yield % (annual rent ÷ purchase price × 100)**, calculated per listing and aggregated by area, property type, price band, and bedroom count. This is the standard metric buy-to-let investors use to compare properties, and the only metric this dataset can support honestly (see Data Notes below).

## 5. Evidence

| Finding | Value | Source |
|---|---|---|
| Portfolio average yield | 7.05% | `sql/investor_yield_analysis.sql` — Q1 |
| Top yield area | Jebel Ali — 10.14% | Q2 / `excel` Area Summary |
| Bottom yield area | The Meadows — 4.59% | Q3 / `excel` Area Summary |
| Yield by type: Apartment | 7.31% (highest of all types) | Q4 / `excel` Type Summary |
| Yield by type: Villa | 5.68% (lowest of all types) | Q4 / `excel` Type Summary |
| "Average" price band yield | 8.59% | Q5 / `excel` Price Band Summary |
| "High" price band yield | 5.79% | Q5 / `excel` Price Band Summary |
| Furnishing effect on yield | Negligible (7.09% vs 6.98%) | Q6 — ruled out as a marketing lever |
| Best area+type combo, min. 30 listings | Discovery Gardens Apartments — 9.82% | Q8 |
| Studio yield vs. 5-bed yield | 8.42% vs 5.37% | Q9 / `excel` Beds Summary |

Every figure above is reproducible from `sql/investor_yield_analysis.sql` (validated against the cleaned dataset) and cross-checked live in the Excel workbook's formula-driven summary tabs — the two independently agree to two decimal places.

## 6. Recommendations

1. **Lead investor campaigns with JVC, Dubai Production City, Discovery Gardens, and Dubai Sports City** — all combine strong yield (8.7%–9.2%) with enough listing volume (100+ each) to sustain an ongoing campaign, not just a lucky small sample.
2. **Message apartments, not villas, for yield-driven campaigns.** Villas can still be marketed, but on appreciation and lifestyle — not rental return.
3. **Use studios and 1-beds as the entry-level investor product** — they show the highest yield of any bedroom count and the lowest capital outlay, a natural first-time-investor pitch.
4. **Drop furnishing status as a campaign angle** — it has almost no effect on yield, so "furnished for higher returns" isn't a claim this data supports.
5. **Treat premium villa communities as a separate campaign track**, not a yield pitch — The Meadows, Jumeirah Islands, Nad Al Sheba, and Arabian Ranches all sit well below the portfolio average.

---

## Data Notes (read before using these numbers)

- **Source:** Bayut "For Sale" property listings, published on Kaggle as [Dubai Real Estate Sales Insights](https://www.kaggle.com/datasets/azharsaleem/dubai-real-estate-sales-insights) (`bayut_selling_properties.csv`, 41,381 rows, 22 columns).
- **This is asking-price listing data, not confirmed sold-price data**, and it's a single snapshot per listing (one `post_date`, no sale-close date). This dataset **cannot** support claims about time-to-sell or sales velocity — this project makes none.
- **Cleaning applied:** filtered to Dubai + `price > 0` (dropped 16 zero-price rows and 2 rows with a corrupted city value); kept only listings with real `average_rent` data — roughly half of all rows had rent recorded as `0`, which is a "not disclosed" placeholder rather than a true value, so those rows were excluded rather than treated as zero; calculated `yield_pct = (average_rent / price) × 100`; capped yield to a realistic 1%–20% range, removing 7 outlier rows from data-entry errors (one row implied a 475% yield).
- **Final clean dataset: 15,605 listings**, all `completion_status = Ready` — off-plan units had no rental history, so they drop out of a yield-based cut naturally. This is a **ready/secondary-market investor analysis**, not an off-plan one.

## Repository Structure

```
├── data/
│   └── cleaned_dubai_yield_data.csv       # 15,605 cleaned listings, ready for analysis
├── sql/
│   └── investor_yield_analysis.sql        # 9 queries, each with a stated business purpose
├── excel/
│   └── Dubai_Investor_Yield_Analysis.xlsx # Formula-driven summary tabs + charts, zero formula errors
├── dashboard/
│   └── index.html                         # Interactive yield ledger — open directly in any browser
└── README.md
```

## Tools Used

Python (pandas) for cleaning and validation · SQL (SQLite syntax, portable to MySQL) for the query layer · Excel (openpyxl, formula-driven — SUMIFS/AVERAGEIFS/COUNTIFS/MINIFS/MAXIFS) for the workbook · HTML/CSS/JS for the interactive dashboard.

---

*Part of a data analytics portfolio built by a linguist transitioning into data analytics for the UAE market. See also: QuickCart Complaint Analyzer (NLP/text), Last-Mile Delivery Dashboard (operations), JD Text Analyzer (linguistics + business data).*
