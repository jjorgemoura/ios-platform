# Demo app

A multiplatform SwiftUI app (iOS, iPadOS and macOS) used to test and validate the __MODULE__ library.

Open it with `make demo` from the repository root. This opens `__MODULE__.xcworkspace`, which
includes the package and the demo project. Build through the workspace rather than
`DemoApp.xcodeproj` on its own, because the project only finds the `__MODULE__` package through the
workspace.
