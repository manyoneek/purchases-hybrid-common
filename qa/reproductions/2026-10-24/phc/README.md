# Product price regressions — October 24, 2026

Two independent fixes verified against Hybrid Common `ed23f3f08d1abe97d0ebe591b708bb984f8c2ced` (19.15.1).

- **iOS:** lifetime product period-price fields disappear instead of serializing as null. A documented JavaScript null guard throws. Native shared-library app: 4 passes / 7 failures before, 11 passes after. Original native suite: 162 passes. Regression suite before: 17 passes / 7 failing cases (13 assertions, including the old key-count expectation). Fixed full suite: 169 passes.
- **Web only:** numeric period prices are returned in micros. Real browser client: 1 pass / 3 failures before, 4 passes after. Original Jest suite: 57 passes. Identical corrected expectations/regressions: 58 passes / 4 failures before, 62 passes after. API extractor validation passes unchanged.

[Runnable source](source.zip) includes the exact SDK snapshot, native app, web client, dependency locks, separate patches and build instructions. [Commands](commands.json), [complete sanitized logs](logs.zip), [manifest](manifest.json), and separate iOS/web history records preserve the exact evidence. Historical introduction tests remain dated October 17; they were not rerun today.

Fresh [before](evidence/before.mp4) / [after](evidence/fixed.mp4) native recordings and [before](evidence/web-before.mp4) / [after](evidence/web-fixed.mp4) web recordings are continuous app captures. Matching PNGs and raw app results are in [evidence](evidence). English captioned explainers are in [explainers](explainers), with transcripts and scene sources; they include explanatory cards and brief held final frames.

Native dependencies: RevenueCat 5.98.0; web dependency: purchases-js 1.73.1. The native client directly uses the actual shared library and JavaScriptCore; it is not a full wrapper-framework integration. Web evidence is web-only. Both use real dedicated Test Store responses and synthetic users; neither requires a purchase.

Project: **SDK Bug Reporter** (`proj602cc762`). App: **Test Store** (`app4ca00b430f`). [Dashboard](https://app.revenuecat.com/projects/602cc762/apps/app4ca00b430f).

The fixes preserve public declarations. Consumers that manually divide the web period-price values by a million should remove that workaround when adopting the web fix.
