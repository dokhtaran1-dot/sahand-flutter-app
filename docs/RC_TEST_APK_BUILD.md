# RC TEST APK — build and rollout checklist

The published Royal One entrypoint (lib/main.dart) is unchanged.
The separate test APK uses lib/main_rc_staging.dart and Android debug applicationIdSuffix '.dev'.
It will install separately from an app whose application ID is com.example.sahand_consortium,
but verify the installed production application ID before installing.

## Build
GitHub Actions workflow: .github/workflows/rc-staging-apk.yml.
Requires repository Actions enabled and secrets RC_SUPABASE_URL and RC_SUPABASE_ANON_KEY.
Use only the public anon/publishable key, NEVER the service_role key.
The workflow runs flutter test and flutter build apk --debug, uploads
royal-one-rc-test-apk artifact on successful execution.
An APK has NOT been verified until the workflow completes successfully.

## Database
Do NOT apply migrations to the existing production Supabase project.
Use a staging database/project or a reviewed isolation strategy first.
Run the three migrations in order; review the schema/RPC permissions.
Existing public.royal_club_scores and rc.wallets are separate accounting systems:
do not synchronize or redeem points until reconciled and tested.
A separate staging Auth user must be provisioned for email OTP
(signInWithOtp uses shouldCreateUser:false).

## Test
Verify login, 25 initial tickets, daily claim idempotency, 3-ticket entry,
26 cases, banker offers at specified counts, Deal vs No Deal settlement,
one award per round, duplicate request rejection, cross-user access rejection,
and no live prize redemption. Test app on an actual Android device.
The current staging page has no Crown, Find the Difference or skill bonus.
No claims of complete implementation or legal/platform compliance.
