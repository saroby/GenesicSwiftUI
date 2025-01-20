import XCTest
@testable import GenesicSwiftUI

final class GenesicSwiftUITests: XCTestCase {
    // MARK: - Int Extension Tests
    func testRandomInt() {
        let randomValue = Int.random()
        XCTAssert((0...1_000_000).contains(randomValue), "Random Int is out of the expected range (0...1,000,000)")
    }
    
    // MARK: - String Extension Tests
    func testRandomStringSentence() {
        let randomSentence = String.random(.sentence)
        XCTAssertEqual(randomSentence, "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                       "Random String (sentence) did not return the expected value")
    }
    
    func testRandomStringUserID() {
        let randomUserID = String.random(.userID)
        XCTAssertEqual(randomUserID, "Lorem", "Random String (userID) did not return the expected value")
    }
    
    func testRandomStringUserName() {
        let randomUserName = String.random(.userName)
        XCTAssertEqual(randomUserName, "Lorem", "Random String (userName) did not return the expected value")
    }
    
    // MARK: - Date Extension Tests
    func testRandomDate() {
        let randomDate = Date.random()
        let now = Date()
        XCTAssert(abs(randomDate.timeIntervalSinceNow) < 1.0, "Random Date did not return the current date correctly")
    }
}
