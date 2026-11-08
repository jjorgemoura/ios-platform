# Project rules (shared)

This block is synced from the `ios-platform` repo. Edit it there, not here.

The standards behind these rules live in `standards/` of `jjorgemoura/ios-platform`. Read the
relevant file there before changing how a library is built, tested, documented or released.

- Swift 6 language mode with complete strict concurrency (CONC-1).
- A library never depends on another library in this set (API-1).
- Every public symbol has a DocC comment (DOC-1).
- Unit and integration tests use Swift Testing (TEST-1).
