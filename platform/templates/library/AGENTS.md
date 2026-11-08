## __MODULE__

__DESCRIPTION__

### Layout
- `Sources/__MODULE__/` is the library. Public API needs doc comments, and the DocC catalog
  lives in `__MODULE__.docc`.
- `Tests/__MODULE__Tests/Fixtures/` holds sample files for tests. Name them for what they
  exercise.
- `Examples/DemoApp.xcodeproj` is the demo app.

### Behaviour to preserve
<!-- TODO: Rules a change must not break (strict versus lenient input, output format, ...). -->

### Gotchas
- Build the demo through `__MODULE__.xcworkspace`, never `-project`. The project doesn't declare
  the package, so the `__MODULE__` product only resolves through the workspace.
- SwiftLint caches results locally, so a stale cache can hide violations that CI finds.
  `make lint` skips the cache. For Xcode, run `rm -rf ~/Library/Caches/SwiftLint`.
- CI logic is not in this repo. `.github/workflows/` holds thin callers of the reusable
  workflows in `__OWNER__/ios-platform`, pinned to a tag. Change CI there, not here.
- Every platform in `Package.swift` is built in CI, and the `platforms` input of the shared
  workflow must match. Adding or dropping a platform means updating both.

### Verifying changes
- Run `make lint` and `make test` before pushing. The `Makefile` has the other targets.
- For anything the demo app touches, build the `DemoApp` scheme from the workspace for both
  iOS Simulator and macOS, and check that `make demo` still opens.
