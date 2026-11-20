# Royal Club implementation — isolated experimental branch

## Approved specification
- Signup: 20 free non-transferable tickets; daily login: 5.
- Find the Difference: 1 ticket; Crown: 2; Deal: 3.
- Deal: 26 shuffled display-only values, selected case, banker offers.
- Skills: logic 10, pattern 15, speed 20, maximum 45 redeemable points per round.
- Rewards: drinks, desserts, RV dinner, VIP dinner, special competitions.
- Management monthly budget: 500,000,000 toman.

## Implemented on this branch
- Pure Dart rules and local Deal round model.
- Unit tests for ticket costs, skill cap, case values, and duplicate case opening.
- No changes to home, SC sphere, RV, RH, RS, or published application.

## NOT YET IMPLEMENTED — do not deploy or enable real prizes
- Supabase database migration, RLS, atomic idempotent RPCs, authentication checks.
- Server-authoritative signup/daily claim, entry fees, game sessions and skills.
- Anti-fraud, rate limiting, server-side question evaluation and score ledger.
- Complete 3D game UI, animations, banker progression, skill questions.
- Prize catalog, stock, manager approval, Top 10, budget accounting.
- Integration tests, legal/store review, APK build and device testing.

IMPORTANT: Local Deal results must never credit redeemable points. Client-only checks
are not security boundaries. Server-side idempotency and immutable ledger are required.
