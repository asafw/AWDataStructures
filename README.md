# AWDataStructures

A Swift package of classic CS data structures. Written in 2020 when Swift's standard library had no linked lists, queues, or heaps (a `AWStack` could be faked with `Array`, but no dedicated type existed). The package has been kept up-to-date and modernized, but **most of what it provides now has better-supported native or community alternatives** — see the relevance notes below.

---

## What's in the package

| Type | Description | Complexity |
|---|---|---|
| `AWSinglyLinkedList<T>` | Linked list with O(1) head push/pop and O(1) tail append | push/pop O(1) |
| `AWDoublyLinkedList<T>` | Linked list with O(1) access at both ends | push/pop O(1) |
| `AWQueue<T>` | FIFO queue backed by `AWSinglyLinkedList` | enqueue/dequeue O(1) |
| `AWDeque<T>` | Double-ended queue backed by `AWDoublyLinkedList` | all ops O(1) |
| `AWStack<T>` | LIFO stack backed by `AWSinglyLinkedList` | push/pop O(1) |
| `AWHeap<T: Comparable>` | Binary heap, configurable as min-heap or max-heap | insert/extract O(log n) |

`AWSinglyLinkedList` and `AWDoublyLinkedList` conform to `Sequence` and `CustomStringConvertible`. `AWQueue`, `AWDeque`, `AWStack`, and `AWHeap` conform to `CustomStringConvertible` only. All four higher-level types are value types (`struct`). `AWMinHeap<T>` and `AWMaxHeap<T>` are typealiases for `AWHeap<T>`.

---

## Relevance in 2026

### Largely superseded

| Type | Recommended replacement |
|---|---|
| `Stack<T>` | `Array` + `.append()` / `.popLast()` — idiomatic Swift, same O(1) complexity |
| `Deque<T>` | [`swift-collections` `Deque<T>`](https://github.com/apple/swift-collections) — better cache locality |
| `Queue<T>` | [`swift-collections` `Deque<T>`](https://github.com/apple/swift-collections) — superset of Queue functionality, better cache performance |
| `Heap<T>` | [`swift-collections` `Heap<T>`](https://github.com/apple/swift-collections) — richer API, available since 2023 |

### Still has no direct stdlib equivalent

- **`AWSinglyLinkedList<T>` / `AWDoublyLinkedList<T>`** — Swift's stdlib has never shipped a linked list. `Array` or `swift-collections`' `AWDeque` will outperform pointer-chased nodes in almost every real use case due to cache locality. These types are kept as teaching references — classic CS implementations with no practical production advantage over the alternatives above.

---

## Installation

Add to your `Package.swift`:

```swift
.package(url: "https://github.com/asafw/AWDataStructures.git", from: "2.0.0")
```

Then add `"AWDataStructures"` to your target's dependencies.

---

## Usage

### Queue

```swift
var q = AWQueue<Int>()
q.enqueue(1)
q.enqueue(2)
q.dequeue()   // → 1
q.peek()      // → 2
```

### Deque

```swift
var d = AWDeque<String>()
d.pushBack("b")
d.pushFront("a")
d.pushBack("c")
d.popFront()  // → "a"
d.popBack()   // → "c"
```

### Stack

```swift
var s = AWStack<Int>()
s.push(1)
s.push(2)
s.pop()   // → 2
s.peek()  // → 1
```

### Heap (min or max)

```swift
var minHeap = AWHeap<Int>(order: .min)
minHeap.insert(5)
minHeap.insert(1)
minHeap.insert(3)
minHeap.extract()  // → 1
minHeap.peek()     // → 3

var maxHeap = AWHeap<Int>(order: .max, capacity: 10)
maxHeap.insert(5)
maxHeap.extract()  // → 5
```

### SinglyLinkedList

```swift
let list = AWSinglyLinkedList<Int>()
list.appendToTail(value: 1)
list.appendToTail(value: 2)
list.pushHead(value: 0)
Array(list)  // → [0, 1, 2]
print(list)  // → "0 -> 1 -> 2"
```

### DoublyLinkedList

```swift
let list = AWDoublyLinkedList<Int>()
list.appendToTail(value: 1)
list.appendToTail(value: 2)
list.appendToTail(value: 3)
list.pushHead(value: 0)
list.popHead()  // → 0
list.popTail()  // → 3
Array(list)     // → [1, 2]
print(list)     // → "1 <-> 2"
```

---

## Requirements

- Swift 5.9+
- No platform restriction (iOS, macOS, Linux, etc.)

---

## History

- **v1.0 (2020)** — Original release. All types were `class`-based. Target: iOS 13+, Swift 5.3.
- **v2.0 (2026)** — Major modernization:
  - `AWQueue`, `AWDeque`, `AWStack` converted to `struct` (value semantics).
  - `Dequeue` renamed to `AWDeque` (correct spelling).
  - `AWMinHeap` and `AWMaxHeap` merged into a single generic `Heap<T>` parameterized by `AWHeapOrder`; typealiases retained for compatibility.
  - Heap capacity violations now return `Bool` instead of printing a message.
  - `printList()` removed; all types now conform to `CustomStringConvertible`.
  - `Sequence` conformance added to `AWSinglyLinkedList` and `AWDoublyLinkedList`.
  - Platform restriction removed; package builds on any Swift 5.9+ platform.
  - Real unit tests added (was previously boilerplate-only).

