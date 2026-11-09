/// Placeholder entry point. Shared domain, storage and utilities used by every app and feature
/// package live here.
public struct Core: Sendable {
    /// Creates a new instance.
    public init() {
        // Nothing to configure yet.
    }

    /// Returns a greeting, so a new package has something to test.
    public func greeting() -> String {
        "Hello from Core"
    }
}
