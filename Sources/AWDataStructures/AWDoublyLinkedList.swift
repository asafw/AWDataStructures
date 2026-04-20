//
//  AWDoublyLinkedList.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

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
