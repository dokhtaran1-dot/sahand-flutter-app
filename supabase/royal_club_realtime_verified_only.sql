-- Keep verified/read-only Royal Club leaderboard updates in Realtime.
-- Pending score claims are deliberately excluded from this publication.
DO $migration$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime' AND schemaname = 'public'
      AND tablename = 'royal_club_scores'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.royal_club_scores;
  END IF;
END
$migration$;
