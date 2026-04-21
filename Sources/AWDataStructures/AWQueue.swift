//
//  AWQueue.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

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

extension AWQueue: Equatable where T: Equatable {
    public static func == (lhs: AWQueue<T>, rhs: AWQueue<T>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return zip(lhs.list, rhs.list).allSatisfy { $0 == $1 }
    }
}
