//
//  AWHeap.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

/// Specifies the ordering for an `AWHeap`.
public enum AWHeapOrder {
    /// The smallest element is at the root (min-heap).
    case min
    /// The largest element is at the root (max-heap).
    case max
}

/// A binary heap that can operate as either a min-heap or a max-heap.
///
/// - `AWHeapOrder.min` — root is always the smallest element.
/// - `AWHeapOrder.max` — root is always the largest element.
///
/// `AWMinHeap<T>` and `AWMaxHeap<T>` typealiases are provided so existing call
/// sites continue to compile. Create them with `AWHeap(order: .min)` or
/// `AWHeap(order: .max)`.
///
/// - Important: `AWMinHeap<T>` and `AWMaxHeap<T>` are typealiases for `AWHeap<T>`
///   and do not enforce the order at the type level. Always pass the
///   correct `AWHeapOrder` at construction time.
///
/// If you already depend on `swift-collections`, prefer its `Heap<T>`.
/// This type is kept as a dependency-free alternative.
///
/// ### Complexity
/// - `peek`: O(1)
/// - `insert`: O(log n)
/// - `extract`: O(log n)
/// - Space: O(n)
///
/// - Note: Insertion beyond `capacity` returns `false` rather than silently
///   dropping values.
public struct AWHeap<T: Comparable> {
    public let order: AWHeapOrder
    public private(set) var capacity: Int?
    private var storage: [T] = []

    public var size: Int { storage.count }
    public var isEmpty: Bool { storage.isEmpty }

    public init(order: AWHeapOrder, capacity: Int? = nil) {
        self.order = order
        self.capacity = capacity
    }

    /// Returns the root element without removing it, or `nil` if empty.
    public func peek() -> T? {
        storage.first
    }

    /// Inserts `value` into the heap in O(log n).
    ///
    /// - Returns: `true` on success, `false` if the heap has reached its capacity.
    @discardableResult
    public mutating func insert(_ value: T) -> Bool {
        if let cap = capacity, storage.count >= cap { return false }
        storage.append(value)
        siftUp(from: storage.count - 1)
        return true
    }

    /// Removes and returns the root element in O(log n), or `nil` if empty.
    @discardableResult
    public mutating func extract() -> T? {
        guard !storage.isEmpty else { return nil }
        storage.swapAt(0, storage.count - 1)
        let root = storage.removeLast()
        siftDown(from: 0)
        return root
    }

    private func higherPriority(_ a: T, _ b: T) -> Bool {
        order == .min ? a < b : a > b
    }

    private mutating func siftUp(from childIndex: Int) {
        guard childIndex > 0 else { return }
        let parentIndex = (childIndex - 1) / 2
        if higherPriority(storage[childIndex], storage[parentIndex]) {
            storage.swapAt(childIndex, parentIndex)
            siftUp(from: parentIndex)
        }
    }

    private mutating func siftDown(from parentIndex: Int) {
        let left = 2 * parentIndex + 1
        let right = 2 * parentIndex + 2
        var candidate = parentIndex

        if left < storage.count && higherPriority(storage[left], storage[candidate]) {
            candidate = left
        }
        if right < storage.count && higherPriority(storage[right], storage[candidate]) {
            candidate = right
        }
        guard candidate != parentIndex else { return }
        storage.swapAt(parentIndex, candidate)
        siftDown(from: candidate)
    }
}

extension AWHeap: CustomStringConvertible {
    public var description: String {
        "\(order == .min ? "AWMinHeap" : "AWMaxHeap")\(storage)"
    }
}

/// A min-heap: root is always the smallest element.
/// - Note: This is a typealias for `AWHeap<T>`. The order is not enforced by
///   the type system; you must pass `AWHeapOrder.min` at construction:
///   `var h: AWMinHeap<Int> = AWHeap(order: .min)`
public typealias AWMinHeap<T: Comparable> = AWHeap<T>

/// A max-heap: root is always the largest element.
/// - Note: This is a typealias for `AWHeap<T>`. The order is not enforced by
///   the type system; you must pass `AWHeapOrder.max` at construction:
///   `var h: AWMaxHeap<Int> = AWHeap(order: .max)`
public typealias AWMaxHeap<T: Comparable> = AWHeap<T>
