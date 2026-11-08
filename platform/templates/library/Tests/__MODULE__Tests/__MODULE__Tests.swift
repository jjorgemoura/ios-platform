import Testing

@testable import __MODULE__

@Suite("__MODULE__")
struct __MODULE__Tests {
    @Test
    func greeting() {
        #expect(__MODULE__().greeting() == "Hello from __MODULE__")
    }
}
