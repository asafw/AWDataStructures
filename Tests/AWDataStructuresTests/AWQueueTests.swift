import XCTest
@testable import AWDataStructures

final class AWQueueTests: XCTestCase {

    func testEmptyQueueProperties() {
        let q = AWQueue<String>()
        XCTAssertTrue(q.isEmpty)
        XCTAssertEqual(q.count, 0)
        XCTAssertNil(q.peek())
    }

    func testFIFOOrdering() {
        var q = AWQueue<Int>()
        [1, 2, 3].forEach { q.enqueue($0) }
        XCTAssertEqual(q.dequeue(), 1)
        XCTAssertEqual(q.dequeue(), 2)
        XCTAssertEqual(q.dequeue(), 3)
        XCTAssertNil(q.dequeue())
    }

    func testPeekDoesNotRemove() {
        var q = AWQueue<Int>()
        q.enqueue(42)
        XCTAssertEqual(q.peek(), 42)
        XCTAssertEqual(q.count, 1)
    }

    func testCopyHasIndependentStorage() {
        var q1 = AWQueue<Int>()
        q1.enqueue(1)
        var q2 = q1           // copy
        q2.enqueue(2)         // must not affect q1
        XCTAssertEqual(q1.count, 1, "Original queue should be unaffected by mutation of copy")
        XCTAssertEqual(q2.count, 2)
        XCTAssertEqual(q1.peek(), 1)
        XCTAssertEqual(q2.peek(), 1)
    }
}
