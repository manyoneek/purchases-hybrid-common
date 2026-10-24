# RevenueCat SDK review — October 24, 2026

No new confirmed defect. Two existing Hybrid Common findings were reproduced on current upstream and migrated with separate fixes:

- iOS missing null period-price fields: [issue #2022](https://github.com/RevenueCat/purchases-hybrid-common/issues/2022), [PR #2023](https://github.com/RevenueCat/purchases-hybrid-common/pull/2023).
- Web-only period prices in micros: [issue #2024](https://github.com/RevenueCat/purchases-hybrid-common/issues/2024), [PR #2025](https://github.com/RevenueCat/purchases-hybrid-common/pull/2025).

## Coverage and observed results

All 76 public repositories were inventoried and their local clone origins verified. No missing clones. Six direct manyoneek forks were synchronized while preserving contribution/evidence branches. Reviews used isolated worktrees.

Hybrid Common `ed23f3f08d1abe97d0ebe591b708bb984f8c2ced`: inspected product/period-price, introductory pricing, installment and purchase-result mappings across native/shared/web contracts. Original web suite: 57 passes. The identical corrected unit expectations and added regressions produce 58 passes / 4 failures before; all 62 pass after. Build, lint and API extraction pass. Original native suite: 162 passes. Native selected regression suite: 17 passes / 7 failing tests (13 failed assertions); fixed full suite: 169 passes.

Fresh native SharedPriceRepro app uses RevenueCat 5.98.0 and real lifetime/monthly Test Store products: 4 passes / 7 failures before, 11 passes after. It directly links the shared library and evaluates the actual serialized dictionary with JavaScriptCore; this is not a separate hybrid-wrapper app. Fresh web-only client uses purchases-js 1.73.1 and real offerings: 1 pass / 3 failures before, 4 passes after. No fabricated response or purchase. Both 45-second captioned explainers have native playable GitHub players; source, lockfiles, screenshots, continuous recordings, commands and sanitized logs accompany each PR.

Native iOS SDK `c4f9551c86168cea9ced4b69dd56d177a2114574`: reviewed Test Store conversion, default purchase-option fallback, base/trial/introductory prices and period mapping. Four selected existing macOS suites passed 23 tests. Five added checks cover absent purchase options/base prices, nullable description/default fallback, free one-time products and quarterly/incomplete-intro conversion; all 28 pass. No separate full app or new defect is claimed for this review.

React Native PR [#2054](https://github.com/RevenueCat/react-native-purchases/pull/2054): responded to the new scheme-discovery review comment. A fresh local CocoaPods installation could run the four tests even without shared schemes; the claimed CI failure was not reproduced locally. Explicit development-pod scheme sharing now produces the shared RNPurchases test scheme, with React Native's existing installation options preserved. Removing generated user scheme data, the real native bridge tests still give 3 passes / 1 failure before and 4 passes with the fix. This is CI/test-wiring maintenance only; production SDK code and dependency versions are unchanged. October 23 app verification remains dated October 23; no fresh React Native app run was claimed today.

## Duplicate and parity checks

Upstream searches covered open/closed issues and PRs for pricePerWeek, pricePerMonth, period price, micros and null product. Related report bodies and issue/review comments were checked: #621/#1195 introduce/document the iOS fields; #1447 fixes Android units only; #1106 introduces web mapping; #1662 fixes paid introductory prices, a distinct case. #1793/#1907/#1948 explain installment availability and renewal-count semantics. No new installment or API-name-only parity report was filed. Search indexing is bounded and may omit unindexed discussions. [Pinned contract comparison](parity.md).

## Limits and retained work

Six older fork pairs remain pending their own latest-source app verification and migration. All twelve existing findings' publication states were checked; the closed duplicate and resolved findings remain closed. CLI #199/#200 remain open and were not retested. No Android, Unity, physical-device or real-store purchase coverage is claimed.

GitHub permitted issue/PR publication but rejected `pr:fix` label changes because manyoneek lacks label permissions. Both upstream pairs were verified before closing their superseded fork pairs. No direct upstream push or merge; the existing schedule was unchanged.

The first shared-scheme attempt placed `install!` before React Native's helper, which overwrote it; moving the option afterward fixed generation. A build-settings-only probe was unsuitable for a test-only scheme, so verification used actual `xcodebuild test`. The first test-summary export lacked DEVELOPER_DIR and was rerun with the selected Xcode. These were tooling checks, not additional SDK defects. Historical introduction tests were preserved with original dates and limits.
