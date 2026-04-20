import XCTest
@testable import AWDataStructures

// MARK: - AWSinglyLinkedList Tests

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

// MARK: - AWDoublyLinkedList Tests

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

// MARK: - AWQueue Tests

final class QueueTests: XCTestCase {

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

// MARK: - AWDeque Tests

final class DequeTests: XCTestCase {

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
}

// MARK: - AWStack Tests

final class StackTests: XCTestCase {

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
}

// MARK: - AWHeap Tests

final class HeapTests: XCTestCase {

    private func assertMinAWHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = AWHeap<Int>(order: .min)
        values.forEach { heap.insert($0) }
        var extracted: [Int] = []
        while let val = heap.extract() { extracted.append(val) }
        XCTAssertEqual(extracted, values.sorted(), "Min-heap should extract in ascending order", file: file, line: line)
    }

    private func assertMaxAWHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = AWHeap<Int>(order: .max)
        values.forEach { heap.insert($0) }
        var extracted: [Int] = []
        while let val = heap.extract() { extracted.append(val) }
        XCTAssertEqual(extracted, values.sorted(by: >), "Max-heap should extract in descending order", file: file, line: line)
    }

    func testAWMinHeapExtractionOrder() {
        assertMinAWHeapOrder([5, 1, 3, 2, 4])
        assertMinAWHeapOrder([10])
        assertMinAWHeapOrder([3, 3, 1, 2])
    }

    func testAWMaxHeapExtractionOrder() {
        assertMaxAWHeapOrder([5, 1, 3, 2, 4])
        assertMaxAWHeapOrder([10])
        assertMaxAWHeapOrder([3, 3, 1, 2])
    }

    func testAWMinHeapPeekReturnsMinWithoutRemoving() {
        var heap = AWHeap<Int>(order: .min)
        [4, 2, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek(), 1)
        XCTAssertEqual(heap.size, 4)
    }

    func testAWMaxHeapPeekReturnsMaxWithoutRemoving() {
        var heap = AWHeap<Int>(order: .max)
        [4, 2, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek(), 7)
        XCTAssertEqual(heap.size, 4)
    }

    func testEmptyHeapProperties() {
        let heap = AWHeap<Int>(order: .min)
        XCTAssertTrue(heap.isEmpty)
        XCTAssertEqual(heap.size, 0)
        XCTAssertNil(heap.peek())
    }

    func testExtractFromEmptyHeapReturnsNil() {
        var heap = AWHeap<Int>(order: .min)
        XCTAssertNil(heap.extract())
    }

    func testCapacityPreventsOverInsertion() {
        var heap = AWHeap<Int>(order: .min, capacity: 2)
        XCTAssertTrue(heap.insert(1))
        XCTAssertTrue(heap.insert(2))
        XCTAssertFalse(heap.insert(3), "Insert beyond capacity should return false")
        XCTAssertEqual(heap.size, 2)
    }

    func testInsertAndExtractSingleElement() {
        var heap = AWHeap<Int>(order: .min)
        heap.insert(42)
        XCTAssertEqual(heap.extract(), 42)
        XCTAssertTrue(heap.isEmpty)
    }

    func testDescriptionFormat() {
        var heap = AWHeap<Int>(order: .min)
        heap.insert(3)
        heap.insert(1)
        heap.insert(2)
        // description format is "AWMinHeap[<storage array>]" — root must be 1 (min)
        XCTAssertTrue(heap.description.hasPrefix("AWMinHeap["), "AWMinHeap description should start with 'AWMinHeap['")
        XCTAssertTrue(heap.description.contains("1"), "AWMinHeap description should include root element")

        var maxHeap = AWHeap<Int>(order: .max)
        maxHeap.insert(3)
        maxHeap.insert(1)
        maxHeap.insert(2)
        XCTAssertTrue(maxHeap.description.hasPrefix("AWMaxHeap["), "AWMaxHeap description should start with 'AWMaxHeap['")
    }
}
