# Captioned explainer

Actual October 24 app footage and explanatory title cards. No voice narration. Final still frames may be held briefly.

## symptom

Web period prices are 1,000,000 times too large

A $9.99 monthly product returns pricePerMonth = 9990000.
Web-only shared mappings / October 24, 2026

## before

BEFORE / real browser client

Fetch actual Test Store offerings.
Formatted price: $9.99
Numeric monthly price: 9990000

1 check passes / 3 fail

## cause

ROOT CAUSE

The mapper forwards amountMicros unchanged
for week, month and year prices.
The normal product price already divides by 1,000,000.

## fix

FIX

Convert the three values to currency units.
Keep null values, zero prices and formatted strings.

Remove any consumer-side divide-by-a-million workaround
when adopting the fix.

## after

AFTER / same browser client

$9.99 now matches numeric 9.99.
Week and year values also match.

4 checks pass / 0 fail

## verification

VERIFIED ON CURRENT SOURCE

Hybrid Common ed23f3f0 / purchases-js 1.73.1
57 original tests pass.
Identical regressions fail before; all 62 pass after.

Web-only footage. Synthetic Test Store users.