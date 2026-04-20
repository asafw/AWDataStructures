//
//  AWDataStructures.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

// MARK: - SinglyLinkedList

/// A node in a singly-linked list.
public final class Node<T> {
    public var value: T
    public var next: Node?

    public init(value: T) { self.value = value }
}

// MARK: - DoublyLinkedList

/// A node in a doubly-linked list.
public final class DLLNode<T> {
    public var value: T
    /// Weak to break the ARC retain cycle inherent in bidirectional node links.
    public weak var prev: DLLNode?
    public var next: DLLNode?

    public init(value: T) { self.value = value }
}

/// A singly-linked list with O(1) head push/pop and O(1) tail append.
///
/// Swift's standard library has no built-in linked list. This type remains
/// useful as the O(1) backing store for `Queue` — unlike `Array.removeFirst()`
/// which is O(n).
///
/// For most other sequential storage needs, prefer `Array` or, if you need
/// O(1) both-end access, the `Deque` type from `swift-collections`.
public final class SinglyLinkedList<T> {
    public private(set) var head: Node<T>?
    public private(set) var tail: Node<T>?
    public private(set) var count = 0
    public var isEmpty: Bool { count == 0 }

    public init() { }

    /// Appends `value` to the tail in O(1).
    public func appendToTail(value: T) {
        let newNode = Node<T>(value: value)
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
        let newNode = Node<T>(value: value)
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
    func copy() -> SinglyLinkedList<T> {
        let newList = SinglyLinkedList<T>()
        for value in self { newList.appendToTail(value: value) }
        return newList
    }
}

extension SinglyLinkedList: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var current = head
        return AnyIterator {
            defer { current = current?.next }
            return current?.value
        }
    }
}

extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        map { "\($0)" }.joined(separator: " -> ")
    }
}

/// A doubly-linked list with O(1) push/pop at both ends.
///
/// Swift's standard library has no built-in linked list. For O(1) both-end
/// access consider the `Deque` type from `swift-collections`, which has
/// better cache locality. This type remains available as a foundation for
/// the `Deque` type below.
public final class DoublyLinkedList<T> {
    public private(set) var head: DLLNode<T>?
    public private(set) var tail: DLLNode<T>?
    public private(set) var count = 0
    public var isEmpty: Bool { count == 0 }

    public init() { }

    /// Appends `value` to the tail in O(1).
    public func appendToTail(value: T) {
        let newNode = DLLNode<T>(value: value)
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
        let newNode = DLLNode<T>(value: value)
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
    func copy() -> DoublyLinkedList<T> {
        let newList = DoublyLinkedList<T>()
        for value in self { newList.appendToTail(value: value) }
        return newList
    }
}

extension DoublyLinkedList: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var current = head
        return AnyIterator {
            defer { current = current?.next }
            return current?.value
        }
    }
}

extension DoublyLinkedList: CustomStringConvertible {
    public var description: String {
        map { "\($0)" }.joined(separator: " <-> ")
    }
}

// MARK: - Queue

/// A FIFO queue backed by a singly-linked list, providing O(1) enqueue and O(1) dequeue.
///
/// Prefer `swift-collections`'s `Deque<T>` — it is a superset of this type
/// with better cache performance. Use this type only when zero external
/// dependencies is a hard requirement.
///
/// ### Complexity
/// - `enqueue`: O(1)
/// - `dequeue`: O(1)
/// - `peek`: O(1)
/// - Space: O(n)
public struct Queue<T> {
    private var list = SinglyLinkedList<T>()
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

extension Queue: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - Deque

/// A double-ended queue backed by a doubly-linked list with O(1) access at both ends.
///
/// Previously named `Dequeue` (a misspelling). The correct name for the
/// data structure is `Deque`. If you already depend on `swift-collections`,
/// prefer its `Deque<T>` which has better cache performance.
///
/// ### Complexity
/// - `pushFront` / `pushBack`: O(1)
/// - `popFront` / `popBack`: O(1)
/// - `peekFirst` / `peekLast`: O(1)
/// - Space: O(n)
public struct Deque<T> {
    private var list = DoublyLinkedList<T>()
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

extension Deque: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - Stack

/// A LIFO stack backed by a singly-linked list.
///
/// For most use cases, a plain `Array` with `append`/`popLast` is idiomatic
/// Swift and has better cache performance. This type is kept for historical
/// completeness and as a teaching reference.
///
/// ### Complexity
/// - `push` / `pop` / `peek`: O(1)
/// - Space: O(n)
public struct Stack<T> {
    private var list = SinglyLinkedList<T>()
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

extension Stack: CustomStringConvertible {
    public var description: String { list.description }
}

// MARK: - Heap

/// Specifies the ordering for a `Heap`.
public enum HeapOrder {
    /// The smallest element is at the root (min-heap).
    case min
    /// The largest element is at the root (max-heap).
    case max
}

/// A binary heap that can operate as either a min-heap or a max-heap.
///
/// - `HeapOrder.min` — root is always the smallest element.
/// - `HeapOrder.max` — root is always the largest element.
///
/// `MinHeap<T>` and `MaxHeap<T>` typealiases are provided so existing call
/// sites continue to compile. Create them with `Heap(order: .min)` or
/// `Heap(order: .max)`.
///
/// - Important: `MinHeap<T>` and `MaxHeap<T>` are typealiases for `Heap<T>`
///   and do not enforce the order at the type level. Always pass the
///   correct `HeapOrder` at construction time.
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
public struct Heap<T: Comparable> {
    public let order: HeapOrder
    public private(set) var capacity: Int?
    private var storage: [T] = []

    public var size: Int { storage.count }
    public var isEmpty: Bool { storage.isEmpty }

    public init(order: HeapOrder, capacity: Int? = nil) {
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

extension Heap: CustomStringConvertible {
    public var description: String {
        "\(order == .min ? "MinHeap" : "MaxHeap")\(storage)"
    }
}

/// A min-heap: root is always the smallest element.
/// - Note: This is a typealias for `Heap<T>`. The order is not enforced by
///   the type system; you must pass `HeapOrder.min` at construction:
///   `var h: MinHeap<Int> = Heap(order: .min)`
public typealias MinHeap<T: Comparable> = Heap<T>

/// A max-heap: root is always the largest element.
/// - Note: This is a typealias for `Heap<T>`. The order is not enforced by
///   the type system; you must pass `HeapOrder.max` at construction:
///   `var h: MaxHeap<Int> = Heap(order: .max)`
public typealias MaxHeap<T: Comparable> = Heap<T>
