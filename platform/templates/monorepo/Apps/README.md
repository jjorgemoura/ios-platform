# Apps

In development. No app exists yet.

Each app is a thin shell: String catalog, Assets and config values (xcconfig), nothing else. All
logic lives in the packages under `Packages/`. Create an app as `Apps/<Name>/<Name>.xcodeproj`,
add it to `__MODULE__.xcworkspace` and link the local packages it needs.

This folder has an empty `Package.swift` on purpose, so Xcode doesn't list the repository's
files twice. Don't add targets to it.
