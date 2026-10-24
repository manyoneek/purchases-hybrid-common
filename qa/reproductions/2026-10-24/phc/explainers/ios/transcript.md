# Captioned explainer

Actual October 24 app footage and explanatory title cards. No voice narration. Final still frames may be held briefly.

## symptom

Lifetime products lose their null fields

A documented null guard throws TypeError.
Shared iOS library / October 24, 2026

## before

BEFORE / real iOS app

Fetch lifetime + monthly Test Store products.
Six period-price fields are missing.
The JavaScript null guard throws.

4 checks pass / 7 fail

## cause

ROOT CAUSE

Swift dictionary assignment of nil removes a key.
Six optional price fields overwrite NSNull defaults.

The public contract promises explicit null.

## fix

FIX

Coalesce each optional price and formatted string
to NSNull before assigning it.

No public declaration changes.

## after

AFTER / same real app

Six explicit nulls survive serialization.
The null guard returns “not applicable”.
Monthly numeric prices remain intact.

11 checks pass / 0 fail

## verification

VERIFIED ON CURRENT SOURCE

Hybrid Common ed23f3f0 / RevenueCat 5.98.0
Identical regression tests fail before and pass after.
169 shared iOS tests pass with the fix.

Native shared-library client; synthetic Test Store users.