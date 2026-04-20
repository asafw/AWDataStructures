# AWDataStructures

A Swift package of classic CS data structures. Written in 2020 when Swift's standard library had no linked lists, queues, or heaps (a `Stack` could be faked with `Array`, but no dedicated type existed). The package has been kept up-to-date and modernized, but **most of what it provides now has better-supported native or community alternatives** — see the relevance notes below.

---

## What's in the package

| Type | Description | Complexity |
|---|---|---|
| `SinglyLinkedList<T>` | Linked list with O(1) head push/pop and O(1) tail append | push/pop O(1) |
| `DoublyLinkedList<T>` | Linked list with O(1) access at both ends | push/pop O(1) |
| `Queue<T>` | FIFO queue backed by `SinglyLinkedList` | enqueue/dequeue O(1) |
| `Deque<T>` | Double-ended queue backed by `DoublyLinkedList` | all ops O(1) |
| `Stack<T>` | LIFO stack backed by `SinglyLinkedList` | push/pop O(1) |
| `Heap<T: Comparable>` | Binary heap, configurable as min-heap or max-heap | insert/extract O(log n) |

`SinglyLinkedList` and `DoublyLinkedList` conform to `Sequence` and `CustomStringConvertible`. `Queue`, `Deque`, `Stack`, and `Heap` conform to `CustomStringConvertible` only. All four higher-level types are value types (`struct`). `MinHeap<T>` and `MaxHeap<T>` are typealiases for `Heap<T>`.

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

- **`SinglyLinkedList<T>` / `DoublyLinkedList<T>`** — Swift's stdlib has never shipped a linked list. `Array` or `swift-collections`' `Deque` will outperform pointer-chased nodes in almost every real use case due to cache locality. These types are kept as teaching references — classic CS implementations with no practical production advantage over the alternatives above.

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
var q = Queue<Int>()
q.enqueue(1)
q.enqueue(2)
q.dequeue()   // → 1
q.peek()      // → 2
```

### Deque

```swift
var d = Deque<String>()
d.pushBack("b")
d.pushFront("a")
d.pushBack("c")
d.popFront()  // → "a"
d.popBack()   // → "c"
```

### Stack

```swift
var s = Stack<Int>()
s.push(1)
s.push(2)
s.pop()   // → 2
s.peek()  // → 1
```

### Heap (min or max)

```swift
var minHeap = Heap<Int>(order: .min)
minHeap.insert(5)
minHeap.insert(1)
minHeap.insert(3)
minHeap.extract()  // → 1
minHeap.peek()     // → 3

var maxHeap = Heap<Int>(order: .max, capacity: 10)
maxHeap.insert(5)
maxHeap.extract()  // → 5
```

### SinglyLinkedList

```swift
let list = SinglyLinkedList<Int>()
list.appendToTail(value: 1)
list.appendToTail(value: 2)
list.pushHead(value: 0)
Array(list)  // → [0, 1, 2]
print(list)  // → "0 -> 1 -> 2"
```

---

## Requirements

- Swift 5.9+
- No platform restriction (iOS, macOS, Linux, etc.)

---

## History

- **v1.0 (2020)** — Original release. All types were `class`-based. Target: iOS 13+, Swift 5.3.
- **v2.0 (2026)** — Major modernization:
  - `Queue`, `Deque`, `Stack` converted to `struct` (value semantics).
  - `Dequeue` renamed to `Deque` (correct spelling).
  - `MinHeap` and `MaxHeap` merged into a single generic `Heap<T>` parameterized by `HeapOrder`; typealiases retained for compatibility.
  - Heap capacity violations now return `Bool` instead of printing a message.
  - `printList()` removed; all types now conform to `CustomStringConvertible`.
  - `Sequence` conformance added to `SinglyLinkedList` and `DoublyLinkedList`.
  - Platform restriction removed; package builds on any Swift 5.9+ platform.
  - Real unit tests added (was previously boilerplate-only).

