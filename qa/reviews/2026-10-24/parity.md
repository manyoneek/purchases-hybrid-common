# Period-price contract comparison — October 24, 2026

| Implementation / exact source | Public meaning | Current result / evidence |
|---|---|---|
| Hybrid Common TypeScript `ed23f3f08d1abe97d0ebe591b708bb984f8c2ced`, `typescript/src/offerings.ts` | Three numeric prices and three localized strings; null for INAPP products | Existing public declarations; unchanged by either fix. |
| Native iOS `c4f9551c86168cea9ced4b69dd56d177a2114574`, `StoreProduct.swift` | Period prices derive from Decimal currency price; nil for non-subscriptions | Same semantics in app-resolved RevenueCat 5.98.0; real monthly values 2.29 / 9.99 / 119.88. |
| Shared iOS `ed23f3f0`, `StoreProduct+HybridAdditions.swift` | Bridge should preserve nullable native values as explicit JSON null | Nil dictionary assignment removes six keys. Native app confirms the failure and independent fix. |
| Shared Android `ed23f3f0`, `StoreProductMapper.kt` | Price.amountMicros divided by MICROS_CONVERSION_METRIC; missing values remain map entries with null | Source-only comparison; upstream #1447 already fixes Android currency units. No Android runtime test. |
| Web shared mappings `ed23f3f0`, `offerings_mapper.ts`; resolved purchases-js 1.73.1 | Web Price.amountMicros is a micro-unit input; hybrid product fields must match native currency-unit contract | Ordinary price converts correctly but three period fields do not. Real browser client confirms independent web fix. |

These are existing fields with inconsistent serialization/units, not missing APIs or intentionally unsupported platform features. No public declarations change. Consumers with a web divide-by-a-million workaround must remove it when adopting the correction.

Installment review: upstream #1948 explicitly maps iOS commitmentInstallmentsCount to both initial and renewal counts because the renewal commitment is the same on iOS. Its comments also discuss nullable cross-platform fields. This does not establish a new defect; #1793/#1907 are known related historical work. No unsupported claim based solely on repeated assignments or missing names was made.
