//
//  AWDataStructures.swift
//
//  Created by Asaf Weinberg on 11/27/20.
//  Copyright © 2020 Asaf Weinberg. All rights reserved.
//

import Foundation

class Node<T> {
    var value: T
    var next: Node?
    required init(value: T) { self.value = value }
}

class DLLNode<T> {
    var value: T
    var prev: DLLNode?
    var next: DLLNode?
    required init(value: T) { self.value = value }
}

class SinglyLinkedList<T> {
    private (set) var head: Node<T>?
    private (set) var tail: Node<T>?
    private (set) var count = 0
    public var isEmpty: Bool { return count == 0 }
    
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
    
    func pushHead(value: T) {
        let newNode = Node<T>(value: value)
        newNode.next = head
        head = newNode
        count += 1
    }
    
    func popHead() -> T? {
        let retVal = head?.value
        head = head?.next
        if head == nil { tail = nil }
        if count > 0 { count -= 1 }
        return retVal
    }
    
    func printList() {
        var listIter = head
        repeat {
            print(listIter?.value as Any)
            listIter = listIter?.next
        } while listIter != nil
    }
}

class DoublyLinkedList<T> {
    private (set) var head: DLLNode<T>?
    private (set) var tail: DLLNode<T>?
    private (set) var count = 0
    public var isEmpty: Bool { return count == 0 }
    
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
    
    func pushHead(value: T) {
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
    
    func popTail() -> T? {
        let retVal = tail?.value
        tail = tail?.prev
        tail?.next = nil
        if tail == nil { head = nil }
        if count > 0 { count -= 1 }
        return retVal
    }
    
    func popHead() -> T? {
        let retVal = head?.value
        head = head?.next
        head?.prev = nil
        if head == nil { tail = nil }
        if count > 0 { count -= 1 }
        return retVal
    }
    
    func printList() {
        var listIter = head
        repeat {
            print(listIter?.value as Any)
            listIter = listIter?.next
        } while listIter != nil
    }
}

class Queue<T> {
    var list = SinglyLinkedList<T>()
    private (set) var count = 0
    
    func enqueue(value: T) {
        list.appendToTail(value: value)
        count += 1
    }
    
    func dequeue() -> T? {
        if count > 0 { count -= 1 }
        return list.popHead()
    }
    
    func peek() -> T? {
        return list.head?.value
    }
    
    func isEmpty() -> Bool {
        return list.isEmpty
    }
}

class Dequeue<T> {
    var list = DoublyLinkedList<T>()
    private (set) var count = 0
    
    func pushBack(value: T) {
        list.appendToTail(value: value)
        count += 1
    }
    
    func pushFront(value: T) {
        list.pushHead(value: value)
        count += 1
    }
    
    func popBack() -> T? {
        if count > 0 { count -= 1 }
        return list.popTail()
    }
    
    func popFront() -> T? {
        if count > 0 { count -= 1 }
        return list.popHead()
    }
    
    func peekFirst() -> T? {
        return list.head?.value
    }
    
    func peekLast() -> T? {
        return list.head?.value
    }
    
    func isEmpty() -> Bool {
        return list.isEmpty
    }
}

class Stack<T> {
    var list = SinglyLinkedList<T>()
    private (set) var count = 0
    
    func push(value: T) {
        list.pushHead(value: value)
        count += 1
    }
    
    func pop() -> T? {
        if count > 0 { count -= 1 }
        return list.popHead()
    }
    
    func isEmpty() -> Bool {
        return list.isEmpty
    }
    
    func peek() -> T? {
        return list.head?.value
    }
}

class MinHeap<T: Comparable> { //left and right are greater or equal to root
    var heap = [T]()
    private (set) var capacity: Int?
    private (set) var size = 0
    
    required init(capacity: Int? = nil) {
        self.capacity = capacity
    }
    
    func findMin() -> T? {
        return root
    }
    
    func insert(valToInsert: T) { //o(logn)
        if size == capacity {
            print("HEAP FULL")
            return
        }
        heap.append(valToInsert) //added at the end
        siftUp(childIndex: heap.count - 1)
        size += 1
    }
    
    func extractMin() -> T? { //o(logn)
        if heap.isEmpty { return nil }
        
        heap.swapAt(0, heap.count - 1)
        let retVal = heap.last ?? nil
        heap.removeLast()
        siftDown(parentIndex: 0)
        size -= 1
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

class MaxHeap<T: Comparable> { //left and right are smaller or equal to root
    var heap = [T]()
    private (set) var capacity: Int?
    private (set) var size = 0
    
    required init(capacity: Int? = nil) {
        self.capacity = capacity
    }
    
    func findMax() -> T? {
        return root
    }
    
    func insert(valToInsert: T) { //o(logn)
        if size == capacity {
            print("HEAP FULL")
            return
        }
        heap.append(valToInsert) //added at the end
        siftUp(childIndex: heap.count - 1)
        size += 1
    }
    
    func extractMax() -> T? { //o(logn)
        if heap.isEmpty { return nil }
        
        heap.swapAt(0, heap.count - 1)
        let retVal = heap.last ?? nil
        heap.removeLast()
        siftDown(parentIndex: 0)
        size -= 1
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
