//
//  AWDeque.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

/// A double-ended queue backed by a doubly-linked list with O(1) access at both ends.
///
/// Previously named `Dequeue` (a misspelling). The correct name for the
/// data structure is `AWDeque`. If you already depend on `swift-collections`,
/// prefer its `Deque<T>` which has better cache performance.
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
