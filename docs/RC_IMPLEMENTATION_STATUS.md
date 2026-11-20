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

## Revised proposed RC reward thresholds (2026-11-20)
These replace the earlier *proposed* thresholds; prices require final management approval before activation:
- Espresso: 5,000 RP
- RV special drink: 10,000 RP
- Dessert: 15,000 RP
- Breakfast for two: 30,000 RP
- RV dinner for two: 60,000 RP
- VIP dinner for two: 120,000 RP
- Imperial dinner for 6+1: 300,000 RP
- PS5 skill-competition eligibility: 500,000 RP
- Flagship Samsung skill-competition eligibility: 1,000,000 RP
- Flagship iPhone skill-competition eligibility: 1,500,000 RP

Premium rewards are NOT automatic redemptions; they require published competition rules, capacity and management approval. No live redemption until compliance review, budget control and secure server implementation are complete.

## Latest reward catalog scope — supersedes previous catalog (2026-11-20)
User requests ONLY premium prizes such as flagship phones and the other previously listed premium prize(s).
Remove ordinary RV rewards (espresso, drinks, desserts, breakfast, dinners and VIP/Imperial dinners) from the planned redemption catalog.
Retain premium competition prizes: PlayStation 5, flagship Samsung phone, flagship iPhone.
Previously proposed competition eligibility thresholds remain provisional: PS5 500,000 RP; Samsung 1,000,000 RP; iPhone 1,500,000 RP.
Do not activate, promise automatic delivery, or deploy any rewards until user approves final catalog and compliance review completes.
