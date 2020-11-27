# AWDataStructures

* Data Structures in Swift, integrated as a Swift Package

## Version 

* 1.0.0

## Prerequisites

* Xcode 11.5  
* Swift 5  

## Package description 

* Basic Computer Science Data Structures in Swift
* Implementations for: SinglyLinkedList, DoublyLinkedList, Queue, Dequeue, Stack, MinHeap and MaxHeap  
* Data Structures take generic <T> objects

## Detailed description

### Node

* SinglyLinkedList Node Swift implementation
* Public vars: value, next

### DLLNode

* DoublyLinkedList Node Swift implementation
* Public vars: value, prev, next

### SinglyLinkedList

* SinglyLinkedList Swift implementation
* Public methods: appendToTail, pushHead, popHead, printList
* Public vars: head, tail, count, isEmpty

### DoublyLinkedList

* DoublyLinkedList Swift implementation
* Public methods: appendToTail, pushHead, popTail, popHead, printList
* Public vars: head, tail, count, isEmpty

### Queue

* Queue Swift implementation
* Public methods: enqueue, dequeue, peek
* Public vars: count, isEmpty

### Dequeue

* Dequeue Swift implementation
* Public methods: pushBack, pushFront, popBack, popFront, peekFirst, peekLast
* Public vars: count, isEmpty

### Stack

* Stack Swift implementation
* Public methods: push, pop, peek
* Public vars: count, isEmpty

### MinHeap

* MinHeap Swift implementation
* Public methods: findMin, insert, extractMin
* Public vars: size, isEmpty

### MaxHeap

* MaxHeap Swift implementation
* Public methods: findMax, insert, extractMax
* Public vars: size, isEmpty



