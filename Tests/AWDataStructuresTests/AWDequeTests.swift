import XCTest
@testable import AWDataStructures

final class AWDequeTests: XCTestCase {

    func testEmptyDequeProperties() {
        let d = AWDeque<Int>()
        XCTAssertTrue(d.isEmpty)
        XCTAssertEqual(d.count, 0)
        XCTAssertNil(d.peekFirst())
        XCTAssertNil(d.peekLast())
    }

    func testPushAndPopBothEnds() {
        var d = AWDeque<Int>()
        d.pushBack(1)
        d.pushBack(2)
        d.pushFront(0)
        // order: 0, 1, 2
        XCTAssertEqual(d.peekFirst(), 0)
        XCTAssertEqual(d.peekLast(), 2)
        XCTAssertEqual(d.popFront(), 0)
        XCTAssertEqual(d.popBack(), 2)
        XCTAssertEqual(d.count, 1)
    }

    func testPopFrontOrder() {
        var d = AWDeque<Int>()
        [1, 2, 3].forEach { d.pushBack($0) }
        XCTAssertEqual(d.popFront(), 1)
        XCTAssertEqual(d.popFront(), 2)
        XCTAssertEqual(d.popFront(), 3)
    }

    func testPopBackOrder() {
        var d = AWDeque<Int>()
        [1, 2, 3].forEach { d.pushBack($0) }
        XCTAssertEqual(d.popBack(), 3)
        XCTAssertEqual(d.popBack(), 2)
        XCTAssertEqual(d.popBack(), 1)
    }

    func testCopyHasIndependentStorage() {
        var d1 = AWDeque<Int>()
        d1.pushBack(1)
        var d2 = d1         // copy
        d2.pushBack(2)      // must not affect d1
        XCTAssertEqual(d1.count, 1, "Original deque should be unaffected by mutation of copy")
        XCTAssertEqual(d2.count, 2)
    }

    func testDescription() {
        var d = AWDeque<Int>()
        [1, 2, 3].forEach { d.pushBack($0) }
        XCTAssertEqual(d.description, "1 <-> 2 <-> 3")
    }

    func testEqualityAndInequality() {
        var d1 = AWDeque<Int>()
        var d2 = AWDeque<Int>()
        [1, 2, 3].forEach { d1.pushBack($0) }
        [1, 2, 3].forEach { d2.pushBack($0) }
        XCTAssertEqual(d1, d2)
        d2.pushBack(4)
        XCTAssertNotEqual(d1, d2)
    }
}
