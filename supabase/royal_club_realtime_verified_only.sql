-- Expose verified/read-only Royal Club leaderboard updates to Realtime.
-- Pending score claims are a DIFFERENT table, excluded from this publication.
-- End-user clients have no UPDATE/INSERT rights on royal_club_scores.
alter publication supabase_realtime add table public.royal_club_scores;
