import XCTest
@testable import AWDataStructures

// MARK: - SinglyLinkedList Tests

final class SinglyLinkedListTests: XCTestCase {

    func testEmptyListProperties() {
        let list = SinglyLinkedList<Int>()
        XCTAssertTrue(list.isEmpty, "New list should be empty")
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }

    func testAppendToTailUpdatesHeadTailCount() {
        let list = SinglyLinkedList<Int>()
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
        let list = SinglyLinkedList<Int>()
        list.pushHead(value: 1)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 1)

        list.pushHead(value: 2)
        XCTAssertEqual(list.head?.value, 2)
        XCTAssertEqual(list.tail?.value, 1)
        XCTAssertEqual(list.count, 2)
    }

    func testPopHeadReturnsValuesInOrder() {
        let list = SinglyLinkedList<Int>()
        list.pushHead(value: 1)
        list.pushHead(value: 2)
        XCTAssertEqual(list.popHead(), 2)
        XCTAssertEqual(list.popHead(), 1)
        XCTAssertNil(list.popHead())
    }

    func testPopHeadOnEmptyListReturnsNilAndLeavesCountZero() {
        let list = SinglyLinkedList<Int>()
        XCTAssertNil(list.popHead())
        XCTAssertEqual(list.count, 0)
    }

    func testPopHeadClearsHeadAndTailWhenLastNodeRemoved() {
        let list = SinglyLinkedList<Int>()
        list.appendToTail(value: 42)
        list.popHead()
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertTrue(list.isEmpty)
    }

    func testSequenceIteration() {
        let list = SinglyLinkedList<Int>()
        [1, 2, 3].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(Array(list), [1, 2, 3])
    }

    func testCustomStringConvertible() {
        let list = SinglyLinkedList<Int>()
        [1, 2, 3].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(list.description, "1 -> 2 -> 3")
    }
}

// MARK: - DoublyLinkedList Tests

final class DoublyLinkedListTests: XCTestCase {

    func testEmptyListProperties() {
        let list = DoublyLinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
    }

    func testAppendToTail() {
        let list = DoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.head?.value, 1)
        XCTAssertEqual(list.tail?.value, 2)
        XCTAssertEqual(list.count, 2)
    }

    func testPushHead() {
        let list = DoublyLinkedList<Int>()
        list.pushHead(value: 1)
        list.pushHead(value: 2)
        XCTAssertEqual(list.head?.value, 2)
        XCTAssertEqual(list.tail?.value, 1)
    }

    func testPopTailReturnsValuesInOrder() {
        let list = DoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.popTail(), 2)
        XCTAssertEqual(list.popTail(), 1)
        XCTAssertNil(list.popTail())
    }

    func testPopHeadReturnsValuesInOrder() {
        let list = DoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        XCTAssertEqual(list.popHead(), 1)
        XCTAssertEqual(list.popHead(), 2)
        XCTAssertNil(list.popHead())
    }

    func testPopClearsListWhenLastNodeRemoved() {
        let list = DoublyLinkedList<Int>()
        list.appendToTail(value: 99)
        list.popHead()
        XCTAssertNil(list.head)
        XCTAssertNil(list.tail)
        XCTAssertTrue(list.isEmpty)
    }

    func testPrevNextLinksAreCorrect() {
        let list = DoublyLinkedList<Int>()
        list.appendToTail(value: 1)
        list.appendToTail(value: 2)
        list.appendToTail(value: 3)
        XCTAssertEqual(list.head?.next?.value, 2)
        XCTAssertEqual(list.tail?.prev?.value, 2)
        XCTAssertNil(list.head?.prev)
        XCTAssertNil(list.tail?.next)
    }

    func testSequenceIteration() {
        let list = DoublyLinkedList<Int>()
        [10, 20, 30].forEach { list.appendToTail(value: $0) }
        XCTAssertEqual(Array(list), [10, 20, 30])
    }
}

// MARK: - Queue Tests

final class QueueTests: XCTestCase {

    func testEmptyQueueProperties() {
        let q = Queue<String>()
        XCTAssertTrue(q.isEmpty)
        XCTAssertEqual(q.count, 0)
        XCTAssertNil(q.peek())
    }

    func testFIFOOrdering() {
        var q = Queue<Int>()
        [1, 2, 3].forEach { q.enqueue($0) }
        XCTAssertEqual(q.dequeue(), 1)
        XCTAssertEqual(q.dequeue(), 2)
        XCTAssertEqual(q.dequeue(), 3)
        XCTAssertNil(q.dequeue())
    }

    func testPeekDoesNotRemove() {
        var q = Queue<Int>()
        q.enqueue(42)
        XCTAssertEqual(q.peek(), 42)
        XCTAssertEqual(q.count, 1)
    }

    func testCopyHasIndependentStorage() {
        var q1 = Queue<Int>()
        q1.enqueue(1)
        var q2 = q1           // copy
        q2.enqueue(2)         // must not affect q1
        XCTAssertEqual(q1.count, 1, "Original queue should be unaffected by mutation of copy")
        XCTAssertEqual(q2.count, 2)
        XCTAssertEqual(q1.peek(), 1)
        XCTAssertEqual(q2.peek(), 1)
    }
}

// MARK: - Deque Tests

final class DequeTests: XCTestCase {

    func testEmptyDequeProperties() {
        let d = Deque<Int>()
        XCTAssertTrue(d.isEmpty)
        XCTAssertEqual(d.count, 0)
        XCTAssertNil(d.peekFirst())
        XCTAssertNil(d.peekLast())
    }

    func testPushAndPopBothEnds() {
        var d = Deque<Int>()
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
        var d = Deque<Int>()
        [1, 2, 3].forEach { d.pushBack($0) }
        XCTAssertEqual(d.popFront(), 1)
        XCTAssertEqual(d.popFront(), 2)
        XCTAssertEqual(d.popFront(), 3)
    }

    func testPopBackOrder() {
        var d = Deque<Int>()
        [1, 2, 3].forEach { d.pushBack($0) }
        XCTAssertEqual(d.popBack(), 3)
        XCTAssertEqual(d.popBack(), 2)
        XCTAssertEqual(d.popBack(), 1)
    }

    func testCopyHasIndependentStorage() {
        var d1 = Deque<Int>()
        d1.pushBack(1)
        var d2 = d1         // copy
        d2.pushBack(2)      // must not affect d1
        XCTAssertEqual(d1.count, 1, "Original deque should be unaffected by mutation of copy")
        XCTAssertEqual(d2.count, 2)
    }
}

// MARK: - Stack Tests

final class StackTests: XCTestCase {

    func testEmptyStackProperties() {
        let s = Stack<Int>()
        XCTAssertTrue(s.isEmpty)
        XCTAssertEqual(s.count, 0)
        XCTAssertNil(s.peek())
    }

    func testLIFOOrdering() {
        var s = Stack<Int>()
        [1, 2, 3].forEach { s.push($0) }
        XCTAssertEqual(s.pop(), 3)
        XCTAssertEqual(s.pop(), 2)
        XCTAssertEqual(s.pop(), 1)
        XCTAssertNil(s.pop())
    }

    func testPeekDoesNotPop() {
        var s = Stack<Int>()
        s.push(7)
        XCTAssertEqual(s.peek(), 7)
        XCTAssertEqual(s.count, 1)
    }

    func testCopyHasIndependentStorage() {
        var s1 = Stack<Int>()
        s1.push(1)
        var s2 = s1         // copy
        s2.push(2)          // must not affect s1
        XCTAssertEqual(s1.count, 1, "Original stack should be unaffected by mutation of copy")
        XCTAssertEqual(s2.count, 2)
        XCTAssertEqual(s1.peek(), 1)
        XCTAssertEqual(s2.peek(), 2)
    }
}

// MARK: - Heap Tests

final class HeapTests: XCTestCase {

    private func assertMinHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = Heap<Int>(order: .min)
        values.forEach { heap.insert($0) }
        var extracted: [Int] = []
        while let val = heap.extract() { extracted.append(val) }
        XCTAssertEqual(extracted, values.sorted(), "Min-heap should extract in ascending order", file: file, line: line)
    }

    private func assertMaxHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = Heap<Int>(order: .max)
        values.forEach { heap.insert($0) }
        var extracted: [Int] = []
        while let val = heap.extract() { extracted.append(val) }
        XCTAssertEqual(extracted, values.sorted(by: >), "Max-heap should extract in descending order", file: file, line: line)
    }

    func testMinHeapExtractionOrder() {
        assertMinHeapOrder([5, 1, 3, 2, 4])
        assertMinHeapOrder([10])
        assertMinHeapOrder([3, 3, 1, 2])
    }

    func testMaxHeapExtractionOrder() {
        assertMaxHeapOrder([5, 1, 3, 2, 4])
        assertMaxHeapOrder([10])
        assertMaxHeapOrder([3, 3, 1, 2])
    }

    func testMinHeapPeekReturnsMinWithoutRemoving() {
        var heap = Heap<Int>(order: .min)
        [4, 2, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek(), 1)
        XCTAssertEqual(heap.size, 4)
    }

    func testMaxHeapPeekReturnsMaxWithoutRemoving() {
        var heap = Heap<Int>(order: .max)
        [4, 2, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek(), 7)
        XCTAssertEqual(heap.size, 4)
    }

    func testEmptyHeapProperties() {
        let heap = Heap<Int>(order: .min)
        XCTAssertTrue(heap.isEmpty)
        XCTAssertEqual(heap.size, 0)
        XCTAssertNil(heap.peek())
    }

    func testExtractFromEmptyHeapReturnsNil() {
        var heap = Heap<Int>(order: .min)
        XCTAssertNil(heap.extract())
    }

    func testCapacityPreventsOverInsertion() {
        var heap = Heap<Int>(order: .min, capacity: 2)
        XCTAssertTrue(heap.insert(1))
        XCTAssertTrue(heap.insert(2))
        XCTAssertFalse(heap.insert(3), "Insert beyond capacity should return false")
        XCTAssertEqual(heap.size, 2)
    }

    func testInsertAndExtractSingleElement() {
        var heap = Heap<Int>(order: .min)
        heap.insert(42)
        XCTAssertEqual(heap.extract(), 42)
        XCTAssertTrue(heap.isEmpty)
    }
}
