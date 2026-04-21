import XCTest
@testable import AWDataStructures

final class AWDoublyLinkedListTests: XCTestCase {

    func testEmptyListProperties() {
        let list = AWDoublyLinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }

    func testAppendToTail() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
        XCTAssertEqual(list.count, 2)
    }

    func testPushHead() {
        let list = AWDoublyLinkedList<Int>()
        list.pushHead(value: 1)
        list.pushHead(value: 2)
        XCTAssertEqual(list.head?.value, 2)
        XCTAssertEqual(list.tail?.value, 1)
    }

    func testPopTailReturnsValuesInOrder() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.popTail(), 2)
        XCTAssertEqual(list.popTail(), 1)
        XCTAssertNil(list.popTail())
    }

    func testPopHeadReturnsValuesInOrder() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.popHead(), 1)
        XCTAssertEqual(list.popHead(), 2)
        XCTAssertNil(list.popHead())
    }

    func testPopClearsListWhenLastNodeRemoved() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 99)
        list.popHead()
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertTrue(list.isEmpty)
    }

    func testPrevNextLinksAreCorrect() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        list.appendToTail(value: 3)
        XCTAssertEqual(list.head?.next?.value, 2)
        XCTAssertEqual(list.tail?.prev?.value, 2)
        XCTAssertNil(list.head?.prev)
        XCTAssertNil(list.tail?.next)
    }

    func testSequenceIteration() {
        let list = AWDoublyLinkedList<Int>()
        [10, 20, 30].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(Array(list), [10, 20, 30])
    }

    func testCustomStringConvertible() {
        let list = AWDoublyLinkedList<Int>()
        [1, 2, 3].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(list.description, "1 <-> 2 <-> 3")
    }

    func testDescriptionEmptyList() {
        let list = AWDoublyLinkedList<Int>()
        XCTAssertEqual(list.description, "")
    }

    func testPopTailClearsHeadAndTailWhenLastNodeRemoved() {
        let list = AWDoublyLinkedList<Int>()
        list.appendToTail(value: 99)
        list.popTail()
        XCTAssertNil(list.head, "head must be nil after popping last element via popTail")
        XCTAssertNil(list.tail, "tail must be nil after popping last element via popTail")
        XCTAssertTrue(list.isEmpty)
    }

    func testNoRetainCycleOnDealloc() {
        // Each AWDLLNode.prev must be weak; otherwise the bidirectional links form
        // ARC retain cycles and the entire node chain leaks when the list is released.
        weak var midNodeRef: AWDLLNode<Int>?
        do {
            let list = AWDoublyLinkedList<Int>()
            list.appendToTail(value: 1)
            list.appendToTail(value: 2)
            list.appendToTail(value: 3)
            midNodeRef = list.head?.next  // capture a weak ref to the middle node
        }
        XCTAssertNil(midNodeRef, "AWDLLNode should be deallocated when the list is released — prev must be weak")
    }
}
