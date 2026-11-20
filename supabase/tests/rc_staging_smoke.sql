-- Run in an isolated Supabase staging database after all RC migrations.
-- This is a manual SQL smoke-test checklist, not an executed test report.
begin;
do $$
declare n integer;
begin
 select count(*) into n from pg_proc
 where pronamespace='public'::regnamespace and proname in
 ('rc_claim_daily','rc_start_deal','rc_select_deal_case','rc_open_deal_case',
  'rc_settle_final_case','rc_banker_offer','rc_banker_decision');
 if n<>7 then raise exception 'Missing RC RPCs: found %',n; end if;
 if (select count(*) from pg_indexes
     where schemaname='rc' and indexname='rc_one_active_deal_per_user')<>1
 then raise exception 'Missing active-round uniqueness index'; end if;
 if (select count(*) from pg_tables
     where schemaname='rc' and tablename in ('wallets','ledger','deal_rounds'))<>3
 then raise exception 'Missing RC tables'; end if;
end $$;
rollback;
-- Further authenticated tests needed:
-- 1. New user claim -> 25 tickets; same-day repeat -> 25.
-- 2. Next UTC day -> +5 exactly once.
-- 3. Start Deal -> -3; concurrent start -> one active round only.
-- 4. Invalid/duplicate case -> rejected.
-- 5. Banker offer at 6 opens; cannot open more until decision.
-- 6. Rejected offer cannot be replayed; accepted offer credits once.
-- 7. Final settlement at 25 opens credits once; no dual settlement.
-- 8. A different user cannot access or settle another user's round.
-- 9. Direct table writes by authenticated role are denied.
-- 10. Production prize redemption remains disabled.
