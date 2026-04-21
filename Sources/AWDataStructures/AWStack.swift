//
//  AWStack.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

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

extension AWStack: Equatable where T: Equatable {
    public static func == (lhs: AWStack<T>, rhs: AWStack<T>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        return zip(lhs.list, rhs.list).allSatisfy { $0 == $1 }
    }
}
