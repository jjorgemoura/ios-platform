import Testing

@testable import Features

@Suite("Features")
struct FeaturesTests {
    @Test
    func greeting() {
        #expect(Features().greeting() == "Features: Hello from Core")
    }
}
