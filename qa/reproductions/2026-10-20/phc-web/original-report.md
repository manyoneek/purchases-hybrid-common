# Web mappings return period prices one million times too large

**Repository:** RevenueCat/purchases-hybrid-common · **Package:** @revenuecat/purchases-js-hybrid-mappings 19.13.0  
**Commit:** `d1744f694c5cdd3a27baa527c6e1e46d33f4b796`  
**Platform:** web-only, Chrome; purchases-js 1.70.0.

## Reproduce

1. Start the included client: `python3 -m http.server 8887 --bind 127.0.0.1 --directory web-app`.
2. Open `http://127.0.0.1:8887/?variant=before` and click **Run actual SDK flow**.
3. The actual `PurchasesCommon` configures a synthetic user, fetches customer info and offerings, and displays the monthly product's numeric and formatted prices.

**Expected:** numeric per-period prices use major currency units, matching the shared type documentation, native mapper contracts, and the correctly converted `price` field.

**Actual, for the real $9.99/month Test Store product:**

- `pricePerWeek`: **2,290,000**, formatted **$2.29**; expected 2.29.
- `pricePerMonth`: **9,990,000**, formatted **$9.99**; expected 9.99.
- `pricePerYear`: **119,880,000**, formatted **$119.88**; expected 119.88.
- Control: `price` is correctly **9.99**.

**Impact:** custom price labels and price-comparison calculations using numeric per-period fields receive values 1,000,000× too large. Checkout amounts were not tested; this does not establish incorrect charging.

## Tests and suggested fix

`purchases-js-hybrid-mappings/src/mappers/offerings_mapper.ts` forwards `amountMicros` directly for these three fields. Divide by 1,000,000, preserving null and zero values; patch included.

- Existing mapping suite: **57 tests passed**.
- `npm test -- --runInBand --testNamePattern='QA public currency-unit contract'`: **3 fail / 2 pass → 5 pass**. Tests exercise the real mapper; null and zero controls included.
- Same real web client: **1 pass / 3 fail → 4 pass / 0 fail** using `?variant=fixed`.
- Full fixed suite: `npm test -- --runInBand` → **62 passed**, after correcting old expectations that codified micro-unit output.
- Original and fixed production bundles build successfully. Temporary production source fix restored byte-for-byte.

Client: included **web-app**, project **SDK Bug Reporter** (`proj602cc762`), app **Test Store** (`app4ca00b430f`): [dashboard](https://app.revenuecat.com/projects/602cc762/apps/app4ca00b430f).

Evidence: `evidence/web-before.{png,mp4}`, `evidence/web-fixed.{png,mp4}`, corresponding results JSON, `web-suggested-fix.patch`, `web-regression.patch`, and `logs/web-{regression-before,regression-fixed,full-fixed}.log`.

**Limits:** browser/shared-web-client reproduction only. No native mobile reproduction of this bug, checkout, purchase, physical-device or Android test. Real Test Store fetches were used; unit fixtures are separate from app evidence.

## Introduced in

[purchases-hybrid-common #1106](https://github.com/RevenueCat/purchases-hybrid-common/pull/1106) · merged 2025-04-14 · commit [`d57b80dac170`](https://github.com/RevenueCat/purchases-hybrid-common/commit/d57b80dac170e549f92470f20991817cd167b6f1). First stable source tag containing the change: **13.28.1**.

Present since the web offerings mapper was introduced. The initial mapper divides `price` by 1,000,000 but forwards all three period-price `amountMicros` values unchanged. The regression against that historical source produces three failures and two passing null/zero controls; converting the three fields makes all five pass. The parent had no offerings mapper.

**Historical verification limits:** Actual historical mapper and its original fixture helper under Jest, with locally installed test dependencies. No historical web app/backend run. Dependency installation used the historical semver ranges; the resolved lockfile is preserved.

## Latest upstream recheck — 2026-10-20

**still-reproduces** at `466bddb7170d6cef064c347c1c270817dc1617fe`. 3 numeric-price assertions fail by a factor of 1,000,000; null and zero controls pass. Actual current production mapper.

Verification: Local regression revalidation; no new full mobile-app, backend, Android or physical-device execution. Evidence: `revalidation/2026-10-20/logs/purchases-hybrid-common-web-price-regression.log`.
