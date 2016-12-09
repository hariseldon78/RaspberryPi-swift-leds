import XCTest
@testable import leds

class ledsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(leds().text, "Hello, World!")
    }


    static var allTests : [(String, (ledsTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
