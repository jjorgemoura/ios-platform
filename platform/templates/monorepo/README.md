# __MODULE__

__DESCRIPTION__

Private monorepo of the apps released on the App Store. All logic lives in local Swift
packages; the apps are thin shells around them.

## Layout

| Folder | Content |
| --- | --- |
| `Packages/` | Local Swift packages: domain, storage, features and UI per platform |
| `Apps/` | The apps: String catalog, Assets and config values only |

Open `__MODULE__.xcworkspace` (`make demo`) to work on everything.

## Commands

```
make lint                      # swift-format and SwiftLint over every package
make test                      # swift test in every package
make build PLATFORM=watchOS    # build every package for one platform
make format                    # apply swift-format
```

## Status

In development. The packages are placeholders and there is no app yet.
