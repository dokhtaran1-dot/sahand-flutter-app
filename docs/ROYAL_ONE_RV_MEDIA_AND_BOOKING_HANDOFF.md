# Royal One / RV — final real-media upload handoff

## Source files recovered from user's ChatGPT Library
- Royal_Village_45s_REAL_VIDEO.mp4 — original: 1080 × 1920 H.264 + AAC, 45 seconds (40.6 MB).
- ROYAL_VILLAGE_VIRAL_CUT_V2_PREVIEW.mp4 — original: 1080 × 1920 H.264 + AAC, 11.05 seconds (16.7 MB).
- ROYAL_VILLAGE_SAMSUNG_COMPATIBLE.mp4 — original: 720 × 1280 H.264 + AAC, 71.7 seconds (32.2 MB).

These files were **not** stored in GitHub or the APK. Only the user's original files and a separate mobile-friendly conversion are available in the conversation file artifacts. Before public release, confirm what is genuine on-site footage, what is a promotional montage or visualization, and that all footage/audio is cleared for publication.

## Mobile-ready upload package
- RV_Main_45s.mp4 — 720 × 1280 H.264/AAC, 45 s, ~12.7 MB (audio preserved from source).
- RV_Teaser_11s.mp4 — 1080 × 1920 H.264/AAC, 11.05 s, ~16.7 MB.
- Bundle: ROYAL_ONE_RV_MEDIA_READY_WITH_AUDIO.zip (supplied in conversation, not checked into GitHub).

Upload to Supabase project `ROYAL-ONE`, **Storage** -> bucket `royal-one-media`:
- `rv/main_45s.mp4`
- `rv/teaser_11s.mp4`

Bucket has **public read** and no client write policy. This is intentional; only authorized project management uploads media. Maximum file size 50 MB.

Two rows have been prepared in `public.rv_media_assets`, but intentionally remain `published=false`. After uploading and testing each public URL and the original audio, a project administrator may mark the matching row `published=true`. The Royal One RV media page will then display the video *without a new APK build*.

Never mark missing or synthetic assets as real original footage, and never publish an empty or placeholder row.

## Customer booking requests
`public.rv_reservation_requests` receives only phone-verified, consented requests through the app. RLS grants customer SELECT/INSERT only for their own requests; there is **no customer UPDATE/DELETE**. Requests stay `pending` until management reviews them in Supabase Studio. No automatic inventory confirmation or customer charges are enabled.

## RC prizes
`royal_club_scores` is a verified-only public leaderboard and Realtime publication. Score submissions remain pending review; no automatic prize awarding.

## Verified integration checks — November 15, 2026
- A real RLS-scoped database INSERT using a verified existing auth identity was accepted with status `pending` in a **rolled-back SQL transaction**. Follow-up count was **0 reservations**, proving no test bookings were retained. This tests the backend gate, **not SMS delivery on a physical device**.
- Fixed two production DB mismatches: the E.164 phone CHECK regex had been overescaped, and Supabase Auth stores verified phone IDs without the `+` prefix while the app uses `+98...`. RLS now compares normalized values, preserving ownership/phone checks.
- OTP Edge Function `royal1-send-sms` version 4 is deployed and uses a signed Supabase SMS webhook with Kavenegar verification template `RoyalOneOTP`. The phone carrier's **actual delivery and user OTP entry were not tested by this session**.
- An isolated v1.0.30 Android preview implements a resend countdown and clearer expired-code guidance and requires `phoneConfirmedAt` for online bookings; confirm GitHub Actions build and physical device test before publishing.
- Storage inventory check: `royal-one-media` bucket has **0 uploaded objects**, even though approved-only metadata rows for `rv/main_45s.mp4` and `rv/teaser_11s.mp4` exist with `published=false`.
- Contact sheet inspection found world-city/salon concepts (Paris, Seoul, etc). These are promotional assets, **not proof of real on-site rooms or filmed customer experiences**.
- For upload, retrieve the conversation artifact `ROYAL_ONE_RV_SUPABASE_UPLOAD_READY.zip` (29 MB) with exact internal paths. The connected Supabase app supports database/edge operations but **does not have a byte-upload action**. A signed-in admin must use Supabase Dashboard -> Storage to upload both files, verify playback and publish.
