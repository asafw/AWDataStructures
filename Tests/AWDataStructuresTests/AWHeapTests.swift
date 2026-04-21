import XCTest
@testable import AWDataStructures

final class AWHeapTests: XCTestCase {

    private func assertMinHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = AWHeap<Int>(order: .min)
        values.forEach { heap.insert($0) }
        var extracted: [Int] = []
        while let val = heap.extract() { extracted.append(val) }
        XCTAssertEqual(extracted, values.sorted(), "Min-heap should extract in ascending order", file: file, line: line)
    }

    private func assertMaxHeapOrder(_ values: [Int], file: StaticString = #file, line: UInt = #line) {
        var heap = AWHeap<Int>(order: .max)
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
        var heap = AWHeap<Int>(order: .min)
        [4, 2, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek(), 1)
        XCTAssertEqual(heap.size, 4)
    }

    func testMaxHeapPeekReturnsMaxWithoutRemoving() {
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

    func testEqualityAndInequality() {
        var h1 = AWHeap<Int>(order: .min)
        var h2 = AWHeap<Int>(order: .min)
        [3, 1, 2].forEach { h1.insert($0) }
        [3, 1, 2].forEach { h2.insert($0) }
        XCTAssertEqual(h1, h2)
        var h3 = AWHeap<Int>(order: .max)
        [3, 1, 2].forEach { h3.insert($0) }
        XCTAssertNotEqual(h1, h3, "Heaps with different orders should not be equal")
    }
}
