# ROYAL ONE — integration status and release checks

**Source:** integration/rs-offline-assets-pending

## RS (Jafar Dargahi)
- The approved original HTML was restored byte-for-byte in assets/rs/index.html.
- All 10 original full-size PNG concept images were imported and checksum-verified
  against the user's original approved ZIP.
- 4 full-resolution gallery images, original island photo, local font binaries,
  artist data and monogram SVGs are present.
- The original downloaded 10-image *archive ZIP* is not packaged in the APK;
  the individual images are packaged instead.
- The RS Android view loads the HTML from local Flutter assets, without
  depending on an internet connection for gallery images.

## RV
- 8 official private salons appear in the user's confirmed order.
- Photo carousel/gallery navigation, full-size zoom and booking button are in place.
- RV cake and décor galleries are extracted from the existing approved ZIPs
  by the CI workflow before building.

## Heritage
- Emerald-and-gold animated SC identity, father-to-son historical narrative,
  genuine original father photograph and existing nine-chapter book.

## RH
- Keep the approved fully bundled internal HTML site unchanged.

## RC
- Realtime public Top Ten reads only approved points from Supabase.
- Authentication, pending score claims, admin-only verification and RLS are
  separate from official scores; direct client writes to official totals are denied.
- **Not yet a prize-awarding system:** automated server-side game result verification
  is not implemented. Any real rewards require independently validated results.

## APK
- A separate application ID for the staging preview protects the installed app.
- GitHub Actions builds an ARM64 debug APK and releases a prerelease binary.
- This staging APK is **not** the signed Cafe Bazaar / Google Play production build.
- CI build and physical-device testing should be completed before release approval.
