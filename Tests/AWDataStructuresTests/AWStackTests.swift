import XCTest
@testable import AWDataStructures

final class AWStackTests: XCTestCase {

    func testEmptyStackProperties() {
        let s = AWStack<Int>()
        XCTAssertTrue(s.isEmpty)
        XCTAssertEqual(s.count, 0)
        XCTAssertNil(s.peek())
    }

    func testLIFOOrdering() {
        var s = AWStack<Int>()
        [1, 2, 3].forEach { s.push($0) }
        XCTAssertEqual(s.pop(), 3)
        XCTAssertEqual(s.pop(), 2)
        XCTAssertEqual(s.pop(), 1)
        XCTAssertNil(s.pop())
    }

    func testPeekDoesNotPop() {
        var s = AWStack<Int>()
        s.push(7)
        XCTAssertEqual(s.peek(), 7)
        XCTAssertEqual(s.count, 1)
    }

    func testCopyHasIndependentStorage() {
        var s1 = AWStack<Int>()
        s1.push(1)
        var s2 = s1         // copy
        s2.push(2)          // must not affect s1
        XCTAssertEqual(s1.count, 1, "Original stack should be unaffected by mutation of copy")
        XCTAssertEqual(s2.count, 2)
        XCTAssertEqual(s1.peek(), 1)
        XCTAssertEqual(s2.peek(), 2)
    }

    func testDescription() {
        var s = AWStack<Int>()
        [1, 2, 3].forEach { s.push($0) }
        // push uses pushHead, so last pushed is at front
        XCTAssertEqual(s.description, "3 -> 2 -> 1")
    }

    func testEqualityAndInequality() {
        var s1 = AWStack<Int>()
        var s2 = AWStack<Int>()
        [1, 2, 3].forEach { s1.push($0) }
        [1, 2, 3].forEach { s2.push($0) }
        XCTAssertEqual(s1, s2)
        s2.push(4)
        XCTAssertNotEqual(s1, s2)
    }
}
