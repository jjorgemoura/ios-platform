import Testing

@testable import Core

@Suite("Core")
struct CoreTests {
    @Test
    func greeting() {
        #expect(Core().greeting() == "Hello from Core")
    }
}
