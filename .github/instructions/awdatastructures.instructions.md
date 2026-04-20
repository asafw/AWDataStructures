---
applyTo: "**"
---

# AWDataStructures — Copilot Instructions

> Maintained automatically. Update via `.github/CONTEXT.md` + `AGENTS.md`
> and re-sync this file at the end of each session.

## Project overview

A dependency-free Swift package of classic CS data structures. Originally
written in 2020 when Swift's standard library had no linked lists, queues,
or heaps (a Stack could be faked with Array but no dedicated type existed).
Modernized in 2026 (v2.0): value semantics, copy-on-write, Sequence conformance,
merged Heap type, real tests.

- **Repo:** `asafw/AWDataStructures` (public) — `~/Desktop/asafw/AWDataStructures/`
- **Authoritative state:** `.github/CONTEXT.md` — always read before making changes.

---

## Repository layout

```
AWDataStructures/
├── Sources/AWDataStructures/
│   ├── AWSinglyLinkedList.swift  ← AWNode, AWSinglyLinkedList
│   ├── AWDoublyLinkedList.swift  ← AWDLLNode, AWDoublyLinkedList
│   ├── AWQueue.swift
│   ├── AWDeque.swift
│   ├── AWStack.swift
│   └── AWHeap.swift              ← AWHeapOrder, AWHeap, AWMinHeap, AWMaxHeap
├── Tests/AWDataStructuresTests/
│   └── AWDataStructuresTests.swift
├── Package.swift                ← swift-tools-version:5.9, no platform restriction
├── README.md
├── AGENTS.md
└── .github/
    ├── CONTEXT.md
    └── instructions/
        └── awdatastructures.instructions.md  ← this file
```

---

## Types and APIs

### Linked lists (reference types — `final class`)

| Type | Key methods | Complexity |
|---|---|---|
| `AWSinglyLinkedList<T>` | `appendToTail`, `pushHead`, `popHead` | O(1) all |
| `AWDoublyLinkedList<T>` | `appendToTail`, `pushHead`, `popHead`, `popTail` | O(1) all |

Both conform to `Sequence` and `CustomStringConvertible`. Both expose a
package-internal `copy() -> Self` method used for copy-on-write by higher-level types.

> **ARC safety:** `AWDLLNode.prev` is `weak var`. This is mandatory — strong
> bidirectional node links create ARC retain cycles that leak the entire node
> chain when the list is released. Never change `prev` back to a strong reference.

> **Node link mutability:** `AWNode.next` and `AWDLLNode.next`/`AWDLLNode.prev` are
> `public internal(set)`. External consumers can read (traverse) but cannot write
> to node links. Writing from outside the module would silently corrupt `count`,
> `head`, and `tail` invariants.

> **Breaking change (v2.0):** The old `Dequeue<T>` type was renamed to `AWDeque<T>`
> (correct spelling). No backward-compat alias exists.

### Value types (`struct`)

| Type | Semantics | Key methods | Complexity | Status |
|---|---|---|---|---|
| `AWQueue<T>` | FIFO | `enqueue(_:)`, `dequeue()`, `peek()` | O(1) all | Superseded by `swift-collections` `Deque<T>` |
| `AWDeque<T>` | Double-ended | `pushFront/Back`, `popFront/Back`, `peekFirst/Last` | O(1) all | Superseded by `swift-collections` `Deque<T>` |
| `AWStack<T>` | LIFO | `push(_:)`, `pop()`, `peek()` | O(1) all | Superseded by `Array` |
| `AWHeap<T: Comparable>` | Min or max binary heap | `insert(_:) -> Bool`, `extract() -> T?`, `peek()` | O(log n) insert/extract, O(1) peek | Superseded by `swift-collections` `Heap<T>` |

`AWQueue`, `AWDeque`, `AWStack` use **copy-on-write**: each mutating method calls
`makeUnique()`, which deep-copies the backing linked list when the reference
count is > 1.

`AWHeap` is backed by a plain `[T]` array — no CoW wrapper needed.

`AWMinHeap<T>` and `AWMaxHeap<T>` are typealiases for `AWHeap<T>`. They do **not**
enforce order at compile time. Always pass `AWHeapOrder.min` or `AWHeapOrder.max`
at construction.

---

## Coding conventions

- **One file per type** — each public type has its own file named after it
  (`AWSinglyLinkedList.swift`, `AWDoublyLinkedList.swift`, `AWQueue.swift`,
  `AWDeque.swift`, `AWStack.swift`, `AWHeap.swift`).
- **No imports** — the source file must remain import-free. Every API used must
  come from the Swift stdlib.
- **Doc comments** — every `public` type and method must have a `///` doc comment.
  Include a `### Complexity` block for container types.
- **Tests** — every new type or method must have corresponding tests in its
  matching test file (e.g. `AWQueueTests.swift` for `AWQueue`). Use a private
  helper when testing multiple inputs with the same logic (see `assertMinHeapOrder`
  / `assertMaxHeapOrder` in `AWHeapTests.swift`).
- **Value semantics for structs** — any `struct` that wraps a `class` backing
  store must implement CoW via `makeUnique()`. Test it with a copy-and-mutate test.
- **`@discardableResult`** — all `pop` / `extract` / `dequeue` methods must be
  marked `@discardableResult` so callers can ignore the return value without warnings.

---

## Build and test

```bash
swift build
swift test        # must show 41 passed, 0 failed
```

---

## Session end checklist

1. Run `swift test` — all tests must pass.
2. Update `.github/CONTEXT.md`: latest commit hash, test counts, any new types/APIs.
3. Update this file if architecture, conventions, or type descriptions changed.
4. Commit both together:
   ```bash
   git add .github/CONTEXT.md .github/instructions/awdatastructures.instructions.md
   git commit -m "docs(context): update session state"
   git push origin master
   ```
