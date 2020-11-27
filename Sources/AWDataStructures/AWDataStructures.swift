//
//  AWDataStructures.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

import Foundation

public class Node<T> {
    public var value: T
    public var next: Node?
        
    public required init(value: T) { self.value = value }
}

public class DLLNode<T> {
    public var value: T
    public var prev: DLLNode?
    public var next: DLLNode?
    
    public required init(value: T) { self.value = value }
}

public class SinglyLinkedList<T> {
    public private (set) var head: Node<T>?
    public private (set) var tail: Node<T>?
    public private (set) var count = 0
    public var isEmpty: Bool { return count == 0 }
    
    public init() { }
    
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
    
    public func pushHead(value: T) {
        let newNode = Node<T>(value: value)
        newNode.next = head
        head = newNode
        count += 1
    }
    
    public func popHead() -> T? {
        let retVal = head?.value
        head = head?.next
        if head == nil { tail = nil }
        count -= count == 0 ? 0 : 1
        return retVal
    }
    
    public func printList() {
        var listIter = head
        repeat {
            print(listIter?.value as Any)
            listIter = listIter?.next
        } while listIter != nil
    }
}

public class DoublyLinkedList<T> {
    public private (set) var head: DLLNode<T>?
    public private (set) var tail: DLLNode<T>?
    public private (set) var count = 0
    public var isEmpty: Bool { return count == 0 }
    
    public init() { }
    
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
    
    public func popTail() -> T? {
        let retVal = tail?.value
        tail = tail?.prev
        tail?.next = nil
        if tail == nil { head = nil }
        count -= count == 0 ? 0 : 1
        return retVal
    }
    
    public func popHead() -> T? {
        let retVal = head?.value
        head = head?.next
        head?.prev = nil
        if head == nil { tail = nil }
        count -= count == 0 ? 0 : 1
        return retVal
    }
    
    public func printList() {
        var listIter = head
        repeat {
            print(listIter?.value as Any)
            listIter = listIter?.next
        } while listIter != nil
    }
}

public class Queue<T> {
    var list = SinglyLinkedList<T>()
    public var count: Int { return list.count }
    public var isEmpty: Bool { return list.isEmpty }
    
    public init() { }
    
    public func enqueue(value: T) {
        list.appendToTail(value: value)
    }
    
    public func dequeue() -> T? {
        return list.popHead()
    }
    
    public func peek() -> T? {
        return list.head?.value
    }
}

public class Dequeue<T> {
    var list = DoublyLinkedList<T>()
    public var count: Int { return list.count }
    public var isEmpty: Bool { return list.isEmpty }
    
    public init() { }
    
    public func pushBack(value: T) {
        list.appendToTail(value: value)
    }
    
    public func pushFront(value: T) {
        list.pushHead(value: value)
    }
    
    public func popBack() -> T? {
        return list.popTail()
    }
    
    public func popFront() -> T? {
        return list.popHead()
    }
    
    public func peekFirst() -> T? {
        return list.head?.value
    }
    
    public func peekLast() -> T? {
        return list.tail?.value
    }
}

public class Stack<T> {
    var list = SinglyLinkedList<T>()
    public var count: Int { return list.count }
    public var isEmpty: Bool { return list.isEmpty }
    
    public init() { }
    
    public func push(value: T) {
        list.pushHead(value: value)
    }
    
    public func pop() -> T? {
        return list.popHead()
    }

    public func peek() -> T? {
        return list.head?.value
    }
}

public class MinHeap<T: Comparable> { //left and right are greater or equal to root
    var heap = [T]()
    private (set) var capacity: Int?
    public var size: Int { return heap.count }
    public var isEmpty: Bool { return heap.isEmpty }
    
    public init() { }
    
    public required init(capacity: Int? = nil) {
        self.capacity = capacity
    }
    
    public func findMin() -> T? {
        return root
    }
    
    public func insert(valToInsert: T) { //o(logn)
        if heap.count == capacity {
            print("HEAP FULL")
            return
        }
        heap.append(valToInsert) //added at the end
        siftUp(childIndex: heap.count - 1)
    }
    
    public func extractMin() -> T? { //o(logn)
        
        if heap.isEmpty { return nil }
        
        heap.swapAt(0, heap.count - 1)
        let retVal = heap.last ?? nil
        heap.removeLast()
        siftDown(parentIndex: 0)
        return retVal
    }
    
    private func siftUp(childIndex: Int) { //when inserting
        if heap.count < 2 { return }
        let parentIndex = parent(index: childIndex)
        
        if heap[parentIndex] > heap[childIndex] {
            heap.swapAt(parentIndex, childIndex)
            siftUp(childIndex: parentIndex)
        }
    }
    
    private func siftDown(parentIndex: Int) { //when extracting
        if heap.count < 2 { return }
        let leftIndex = left(index: parentIndex)
        let rightIndex = right(index: parentIndex)
        var smallestIndex = parentIndex
        
        if leftIndex < heap.count && heap[leftIndex] < heap[parentIndex] {
            smallestIndex = leftIndex
        }
        
        if rightIndex < heap.count && heap[rightIndex] < heap[smallestIndex] {
            smallestIndex = rightIndex
        }
        
        if smallestIndex == parentIndex { return }
        
        heap.swapAt(parentIndex, smallestIndex)
        siftDown(parentIndex: parentIndex)
    }
    
    private func parent(index: Int) -> Int {
        return (index - 1)/2
    }
    
    private func left(index: Int) -> Int {
        return 2 * index + 1
    }
    
    private func right(index: Int) -> Int {
        return 2 * index + 2
    }
    
    private func isLeaf(index: Int) -> Bool {
        return index >= (heap.count / 2) && index <= heap.count
    }
    
    private var root: T? {
        return heap.isEmpty ? nil : heap[0]
    }
}

public class MaxHeap<T: Comparable> { //left and right are smaller or equal to root
    var heap = [T]()
    private (set) var capacity: Int?
    public var size: Int { return heap.count }
    public var isEmpty: Bool { return heap.isEmpty }
    
    public init() { }
    
    public required init(capacity: Int? = nil) {
        self.capacity = capacity
    }
    
    public func findMax() -> T? {
        return root
    }
    
    public func insert(valToInsert: T) { //o(logn)
        if heap.count == capacity {
            print("HEAP FULL")
            return
        }
        heap.append(valToInsert) //added at the end
        siftUp(childIndex: heap.count - 1)
    }
    
    public func extractMax() -> T? { //o(logn)
        
        if heap.isEmpty { return nil }
        
        heap.swapAt(0, heap.count - 1)
        let retVal = heap.last ?? nil
        heap.removeLast()
        siftDown(parentIndex: 0)
        return retVal
    }
    
    private func siftUp(childIndex: Int) { //when inserting
        if heap.count < 2 { return }
        let parentIndex = parent(index: childIndex)
        
        if heap[parentIndex] < heap[childIndex] {
            heap.swapAt(parentIndex, childIndex)
            siftUp(childIndex: parentIndex)
        }
    }
    
    private func siftDown(parentIndex: Int) { //when extracting
        if heap.count < 2 { return }
        let leftIndex = left(index: parentIndex)
        let rightIndex = right(index: parentIndex)
        var largestIndex = parentIndex
        
        if leftIndex < heap.count && heap[leftIndex] > heap[parentIndex] {
            largestIndex = leftIndex
        }
        
        if rightIndex < heap.count && heap[rightIndex] > heap[largestIndex] {
            largestIndex = rightIndex
        }
        
        if largestIndex == parentIndex { return }
        
        heap.swapAt(parentIndex, largestIndex)
        siftDown(parentIndex: parentIndex)
    }
    
    private func parent(index: Int) -> Int {
        return (index - 1)/2
    }
    
    private func left(index: Int) -> Int {
        return 2 * index + 1
    }
    
    private func right(index: Int) -> Int {
        return 2 * index + 2
    }
    
    private func isLeaf(index: Int) -> Bool {
        return index >= (heap.count / 2) && index <= heap.count
    }
    
    private var root: T? {
        return heap.isEmpty ? nil : heap[0]
    }
}
