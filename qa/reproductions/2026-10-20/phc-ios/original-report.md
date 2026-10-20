# iOS omits nullable period-price fields for non-subscription products

**Repository:** RevenueCat/purchases-hybrid-common · **Version:** 19.13.0  
**Commit:** `d1744f694c5cdd3a27baa527c6e1e46d33f4b796`  
**Platform:** native iOS 27.1 simulator; RevenueCat iOS 5.95.0.

## Reproduce

1. Build/run the included `native-app` with `./build-native.sh before` (set `QA_SIMULATOR`).
2. It configures a synthetic user and calls the actual `CommonFunctionality.getProductInfo` for `bug_reporter_lifetime` and `bug_reporter_monthly`.
3. Inspect the lifetime dictionary and its JSON serialization. Run the included consumer: `product.pricePerMonth !== null ? product.pricePerMonth.toFixed(2) : 'not applicable'`.

**Expected:** `pricePerWeek`, `pricePerMonth`, `pricePerYear` and their three `String` counterparts are explicitly null for a non-subscription product, as documented in `typescript/src/offerings.ts`. The null-guarded consumer returns `not applicable`.

**Actual:** all six fields are absent. The consumer receives undefined and throws `TypeError`; it compiles successfully against the actual shared TypeScript types with strict null checking. Monthly numeric controls remain correct.

**Impact:** valid typed consumers that distinguish null from a price can crash while rendering lifetime/one-time products.

## Tests and suggested fix

`StoreProduct+HybridAdditions.swift` initializes these keys with NSNull, then assigns nil optionals to the dictionary subscript, removing them. Coalesce all six assignments with `?? NSNull()`; patch included.

- Existing iOS baseline: **161 tests passed**.
- `xcodebuild test -workspace PurchasesHybridCommon.xcworkspace -scheme PurchasesHybridCommon -destination "platform=iOS Simulator,id=$QA_SIMULATOR" -only-testing:PurchasesHybridCommonTests/StoreProductHybridAdditionsTests -collect-test-diagnostics never CODE_SIGNING_ALLOWED=NO IPHONEOS_DEPLOYMENT_TARGET=15.0`: six added null cases fail before, each at dictionary and JSON checks; subscription control passes. Selected suite: 24 cases, 18 pass / 6 fail (12 failed assertions).
- Same native app: **4 pass / 7 fail → 11 pass / 0 fail**.
- Full fixed XCTest suite: **168 passed**. The previous dictionary-size assertion is corrected from 12 to 18.
- Temporary production fix restored byte-for-byte. Original failure rechecked after restoration.

Client: **SharedPriceRepro**, project **SDK Bug Reporter** (`proj602cc762`), app **Test Store** (`app4ca00b430f`): [dashboard](https://app.revenuecat.com/projects/602cc762/apps/app4ca00b430f).

Evidence: `evidence/native-before-compact.{png,mp4}`, `evidence/native-fixed.{png,mp4}`, corresponding results JSON; `ios-suggested-fix.patch`, `ios-regression.patch`, `qa-null-guard.ts`, `logs/ios-regression-restored.log` and `logs/ios-full-fixed.log`.

**Limits:** actual shared-library product-fetch flow on a simulator. JavaScriptCore consumes its real serialized result; this is not a React Native/Cordova wrapper reproduction. No purchase, physical device, or Android execution. The separate TypeScript `apitests` script cannot run because its `apitesters/` directory is absent.

## Introduced in

[purchases-hybrid-common #621](https://github.com/RevenueCat/purchases-hybrid-common/pull/621) · merged 2024-07-24 · commit [`d6696547e597`](https://github.com/RevenueCat/purchases-hybrid-common/commit/d6696547e597703811213284a9b935224ff5fc1f). First stable source tag containing the change: **12.0.0**.

Present since the per-period properties were introduced. The original mapper initializes six keys to `NSNull` and then removes them by assigning nil optionals. Executing that unmodified historical mapper reproduces all six missing fields; six non-null controls remain present. The same PR already documented “Null for INAPP products.” [#1195](https://github.com/RevenueCat/purchases-hybrid-common/pull/1195) later corrected TypeScript nullability (2025-07-09); it did not introduce the serialization defect. The parent had no per-period fields.

**Historical verification limits:** Unmodified historical mapper compiled on macOS with synthetic RevenueCat product properties. A separate type alias resolves the current StoreKit name collision. No full 2024 SDK/app build was executed.

## Latest upstream recheck — 2026-10-20

**still-reproduces** at `466bddb7170d6cef064c347c1c270817dc1617fe`. Entire unmodified current Swift mapper omits all 6 absent period-price fields; all 6 populated-field controls survive. Synthetic StoreProduct dependency shim.

Verification: Local regression revalidation; no new full mobile-app, backend, Android or physical-device execution. Evidence: `revalidation/2026-10-20/ios-period-current-results.json`.
