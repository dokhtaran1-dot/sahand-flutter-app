# Royal Club online leaderboard — security and rollout

The Supabase project has a `public.royal_club_scores` table with RLS enabled.
Anonymous and authenticated users may SELECT leaderboard rows only.
Client INSERT, UPDATE, and DELETE are intentionally disabled.

Do NOT enable `ROYAL_CLUB_BACKEND_READY` or award real prizes until a
server-authoritative score verification flow is implemented and tested.

Expected columns: user_id, display_name, deal, crown, difference,
first_played, ticket_balance, lifetime_tickets, updated_at.

Game completion must be verified server-side before crediting points;
client-provided point totals must not be trusted. The table currently has
zero rows. The local leaderboard is only a prototype.

RS offline asset integration is staged in this branch, but its original
binary assets under assets/rs/ are NOT yet in GitHub. Do not build or merge
this branch until all files from
Royal_One_RS_Jafar_Offline_Integration_Ready.zip are uploaded and validated.
