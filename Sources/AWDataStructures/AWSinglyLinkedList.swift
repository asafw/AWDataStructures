//
//  AWSinglyLinkedList.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

/// A node in a singly-linked list.
public final class AWNode<T> {
    public var value: T
    /// The next node. Readable publicly; writable only within the module to
    /// prevent external callers from corrupting list invariants (count, tail).
    public internal(set) var next: AWNode?

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
