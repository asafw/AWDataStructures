//
//  AWDataStructures.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

// MARK: - AWSinglyLinkedList

/// A node in a singly-linked list.
public final class AWNode<T> {
    public var value: T
    /// The next node. Readable publicly; writable only within the module to
    /// prevent external callers from corrupting list invariants (count, tail).
    public internal(set) var next: AWNode?

    public init(value: T) { self.value = value }
}

// MARK: - AWDoublyLinkedList

/// A node in a doubly-linked list.
public final class AWDLLNode<T> {
    public var value: T
    /// Weak to break the ARC retain cycle inherent in bidirectional node links.
    /// Readable publicly; writable only within the module.
    public internal(set) weak var prev: AWDLLNode?
    /// Readable publicly; writable only within the module to prevent external
    /// callers from corrupting list invariants (count, head, tail).
    public internal(set) var next: AWDLLNode?

    public init(value: T) { self.value = value }
}

/// A singly-linked list with O(1) head push/pop and O(1) tail append.
///
/// Swift's standard library has no built-in linked list. This type remains
/// useful as the O(1) backing store for `AWQueue` — unlike `Array.removeFirst()`
/// which is O(n).
///
/// For most other sequential storage needs, prefer `Array` or, if you need
/// O(1) both-end access, the `AWDeque` type from `swift-collections`.
public final class AWSinglyLinkedList<T> {
    public private(set) var head: AWNode<T>?
    public private(set) var tail: AWNode<T>?
    public private(set) var count = 0
    public var isEmpty: Bool { count == 0 }

    public init() { }

    /// Appends `value` to the tail in O(1).
    public func appendToTail(value: T) {
        let newNode = AWNode<T>(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
            tail = newNode
        } else {
            head = newNode
            tail = newNode
        }
        count += 1
    }

    /// Inserts `value` at the head in O(1).
    public func pushHead(value: T) {
        let newNode = AWNode<T>(value: value)
        newNode.next = head
        head = newNode
        if tail == nil { tail = newNode }
        count += 1
    }

    /// Removes and returns the head value in O(1), or `nil` if empty.
    @discardableResult
    public func popHead() -> T? {
        guard let headNode = head else { return nil }
        head = headNode.next
        if head == nil { tail = nil }
        count -= 1
        return headNode.value
    }

    /// Returns a deep copy of this list in O(n).
    func copy() -> AWSinglyLinkedList<T> {
        let newList = AWSinglyLinkedList<T>()
        for value in self { newList.appendToTail(value: value) }
        return newList
    }
}

extension AWSinglyLinkedList: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var current = head
        return AnyIterator {
            defer { current = current?.next }
            return current?.value
        }
    }
}

extension AWSinglyLinkedList: CustomStringConvertible {
    public var description: String {
        map { "\($0)" }.joined(separator: " -> ")
    }
}

/// A doubly-linked list with O(1) push/pop at both ends.
///
/// Swift's standard library has no built-in linked list. For O(1) both-end
/// access consider the `AWDeque` type from `swift-collections`, which has
/// better cache locality. This type remains available as a foundation for
/// the `AWDeque` type below.
public final class AWDoublyLinkedList<T> {
    public private(set) var head: AWDLLNode<T>?
    public private(set) var tail: AWDLLNode<T>?
    public private(set) var count = 0
    public var isEmpty: Bool { count == 0 }

    public init() { }

    /// Appends `value` to the tail in O(1).
    public func appendToTail(value: T) {
        let newNode = AWDLLNode<T>(value: value)
        if let tailNode = tail {
            tailNode.next = newNode
            newNode.prev = tailNode
            tail = newNode
        } else {
            head = newNode
            tail = newNode
        }
        count += 1
    }

    /// Inserts `value` at the head in O(1).
    public func pushHead(value: T) {
        let newNode = AWDLLNode<T>(value: value)
        if let headNode = head {
            headNode.prev = newNode
            newNode.next = headNode
            head = newNode
        } else {
            head = newNode
            tail = newNode
        }
        count += 1
    }

    /// Removes and returns the tail value in O(1), or `nil` if empty.
    @discardableResult
    public func popTail() -> T? {
        guard let tailNode = tail else { return nil }
        tail = tailNode.prev
        tail?.next = nil
        if tail == nil { head = nil }
        count -= 1
        return tailNode.value
    }

    /// Removes and returns the head value in O(1), or `nil` if empty.
    @discardableResult
    public func popHead() -> T? {
        guard let headNode = head else { return nil }
        head = headNode.next
        head?.prev = nil
        if head == nil { tail = nil }
        count -= 1
        return headNode.value
    }

    /// Returns a deep copy of this list in O(n).
    func copy() -> AWDoublyLinkedList<T> {
        let newList = AWDoublyLinkedList<T>()
        for value in self { newList.appendToTail(value: value) }
        return newList
    }
}

extension AWDoublyLinkedList: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var current = head
        return AnyIterator {
            defer { current = current?.next }
            return current?.value
        }
    }
}

extension AWDoublyLinkedList: CustomStringConvertible {
    public var description: String {
        map { "\($0)" }.joined(separator: " <-> ")
    }
}

// MARK: - AWQueue

/// A FIFO queue backed by a singly-linked list, providing O(1) enqueue and O(1) dequeue.
///
/// Prefer `swift-collections`'s `AWDeque<T>` — it is a superset of this type
/// with better cache performance. Use this type only when zero external
/// dependencies is a hard requirement.
///
/// ### Complexity
/// - `enqueue`: O(1)
/// - `dequeue`: O(1)
/// - `peek`: O(1)
/// - Space: O(n)
public struct AWQueue<T> {
    private var list = AWSinglyLinkedList<T>()
    public var count: Int { list.count }
    public var isEmpty: Bool { list.isEmpty }

    public init() { }

    // Ensures the backing storage is not shared before a mutation (copy-on-write).
    private mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&list) {
            list = list.copy()
        }
    }

    /// Adds `value` to the back of the queue in O(1).
    public mutating func enqueue(_ value: T) {
        makeUnique()
        list.appendToTail(value: value)
    }

    /// Removes and returns the front element in O(1), or `nil` if empty.
    @discardableResult
    public mutating func dequeue() -> T? {
        makeUnique()
        return list.popHead()
    }

    /// Returns the front element without removing it, or `nil` if empty.
    public func peek() -> T? {
        list.head?.value
    }
}

extension AWQueue: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - AWDeque

/// A double-ended queue backed by a doubly-linked list with O(1) access at both ends.
///
/// Previously named `Dequeue` (a misspelling). The correct name for the
/// data structure is `AWDeque`. If you already depend on `swift-collections`,
/// prefer its `AWDeque<T>` which has better cache performance.
///
/// ### Complexity
/// - `pushFront` / `pushBack`: O(1)
/// - `popFront` / `popBack`: O(1)
/// - `peekFirst` / `peekLast`: O(1)
/// - Space: O(n)
public struct AWDeque<T> {
    private var list = AWDoublyLinkedList<T>()
    public var count: Int { list.count }
    public var isEmpty: Bool { list.isEmpty }

    public init() { }

    // Ensures the backing storage is not shared before a mutation (copy-on-write).
    private mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&list) {
            list = list.copy()
        }
    }

    /// Adds `value` to the back in O(1).
    public mutating func pushBack(_ value: T) {
        makeUnique()
        list.appendToTail(value: value)
    }

    /// Adds `value` to the front in O(1).
    public mutating func pushFront(_ value: T) {
        makeUnique()
        list.pushHead(value: value)
    }

    /// Removes and returns the back element in O(1), or `nil` if empty.
    @discardableResult
    public mutating func popBack() -> T? {
        makeUnique()
        return list.popTail()
    }

    /// Removes and returns the front element in O(1), or `nil` if empty.
    @discardableResult
    public mutating func popFront() -> T? {
        makeUnique()
        return list.popHead()
    }

    /// Returns the front element without removing it, or `nil` if empty.
    public func peekFirst() -> T? { list.head?.value }

    /// Returns the back element without removing it, or `nil` if empty.
    public func peekLast() -> T? { list.tail?.value }
}

extension AWDeque: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - AWStack

/// A LIFO stack backed by a singly-linked list.
///
/// For most use cases, a plain `Array` with `append`/`popLast` is idiomatic
/// Swift and has better cache performance. This type is kept for historical
/// completeness and as a teaching reference.
///
/// ### Complexity
/// - `push` / `pop` / `peek`: O(1)
/// - Space: O(n)
public struct AWStack<T> {
    private var list = AWSinglyLinkedList<T>()
    public var count: Int { list.count }
    public var isEmpty: Bool { list.isEmpty }

    public init() { }

    // Ensures the backing storage is not shared before a mutation (copy-on-write).
    private mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&list) {
            list = list.copy()
        }
    }

    /// Pushes `value` onto the top in O(1).
    public mutating func push(_ value: T) {
        makeUnique()
        list.pushHead(value: value)
    }

    /// Removes and returns the top element in O(1), or `nil` if empty.
    @discardableResult
    public mutating func pop() -> T? {
        makeUnique()
        return list.popHead()
    }

    /// Returns the top element without removing it, or `nil` if empty.
    public func peek() -> T? {
        list.head?.value
    }
}

extension AWStack: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - AWHeap

/// Specifies the ordering for a `AWHeap`.
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
/// If you already depend on `swift-collections`, prefer its `AWHeap<T>`.
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
