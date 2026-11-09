import Core

/// Placeholder feature. It shows a feature package building on `Core`. Replace it, or split it
/// into one package per feature or per platform UI.
public struct Features: Sendable {
    /// Creates a new instance.
    public init() {
        // Nothing to configure yet.
    }

    /// Returns a greeting that builds on `Core`.
    public func greeting() -> String {
        "Features: " + Core().greeting()
    }
}
