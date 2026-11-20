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

## Approved change — Royal Points (RP)
- Use the single user-facing name **Royal Points (RP)** for all game points.
- Deal case values and accepted banker DEAL offers are intended to credit **redeemable RP**, not display-only points.
- Correct skill challenges may additionally award up to 45 RP per round.
- Ticket balance remains separate from RP balance; tickets remain free and non-transferable.
- Do not enable prize redemption or publish this chance-based reward mechanic before legal and app-store compliance review.
- Implement banker acceptance, case resolution and RP credit only through authenticated, atomic, idempotent server-side operations. Client display values must never directly mutate wallet balances.
- The previous display-only Deal logic and documentation are superseded by this product decision, but existing code is NOT yet a compliant or complete implementation.
