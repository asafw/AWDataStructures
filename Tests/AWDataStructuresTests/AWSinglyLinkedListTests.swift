import XCTest
@testable import AWDataStructures

final class AWSinglyLinkedListTests: XCTestCase {

    func testEmptyListProperties() {
        let list = AWSinglyLinkedList<Int>()
        XCTAssertTrue(list.isEmpty, "New list should be empty")
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }

    func testAppendToTailUpdatesHeadTailCount() {
        let list = AWSinglyLinkedList<Int>()
        list.appendToTail(value: 1)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 1)
        XCTAssertEqual(list.count, 1)

        list.appendToTail(value: 2)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
        XCTAssertEqual(list.count, 2)
    }

    func testPushHeadUpdatesHeadTailCount() {
        let list = AWSinglyLinkedList<Int>()
        list.pushHead(value: 1)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 1)

        list.pushHead(value: 2)
        XCTAssertEqual(list.head?.value, 2)
        XCTAssertEqual(list.tail?.value, 1)
        XCTAssertEqual(list.count, 2)
    }

    func testPopHeadReturnsValuesInOrder() {
        let list = AWSinglyLinkedList<Int>()
        list.pushHead(value: 1)
        list.pushHead(value: 2)
        XCTAssertEqual(list.popHead(), 2)
        XCTAssertEqual(list.popHead(), 1)
        XCTAssertNil(list.popHead())
    }

    func testPopHeadOnEmptyListReturnsNilAndLeavesCountZero() {
        let list = AWSinglyLinkedList<Int>()
        XCTAssertNil(list.popHead())
        XCTAssertEqual(list.count, 0)
    }

    func testPopHeadClearsHeadAndTailWhenLastNodeRemoved() {
        let list = AWSinglyLinkedList<Int>()
        list.appendToTail(value: 42)
        list.popHead()
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertTrue(list.isEmpty)
    }

    func testSequenceIteration() {
        let list = AWSinglyLinkedList<Int>()
        [1, 2, 3].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(Array(list), [1, 2, 3])
    }

    func testCustomStringConvertible() {
        let list = AWSinglyLinkedList<Int>()
        [1, 2, 3].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(list.description, "1 -> 2 -> 3")
    }

    func testDescriptionEmptyList() {
        let list = AWSinglyLinkedList<Int>()
        XCTAssertEqual(list.description, "")
    }
}
