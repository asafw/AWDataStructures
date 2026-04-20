# AWDataStructures — Project State

> Authoritative context document for AI-assisted development.
> Update at the end of every session that makes code changes.

## Repo
- Path: `~/Desktop/asafw/AWDataStructures/`
- GitHub: `asafw/AWDataStructures` (public)
- Latest commit: `3da10ba` — refactor: split tests into per-type files
- Branch: `master`

## Build Commands
```bash
swift build
swift test
```

## Package
- `swift-tools-version`: 5.9
- No external dependencies
- No platform restriction — pure Swift stdlib, builds on iOS, macOS, Linux, Windows, WASM
- Zero imports in source (no Foundation, no Darwin, no platform frameworks)

## Relevance (2026)
All four higher-level types are superseded by better alternatives:

| Type | Superseded by |
|---|---|
| `Queue<T>` | `swift-collections` `Deque<T>` — superset, better cache performance |
| `Deque<T>` | `swift-collections` `Deque<T>` — better cache locality |
| `Stack<T>` | `Array` + `.append()` / `.popLast()` — idiomatic Swift |
| `Heap<T>` | `swift-collections` `Heap<T>` — richer API |

`AWSinglyLinkedList` and `AWDoublyLinkedList` have no stdlib equivalent but have no practical production advantage over `Array`/`swift-collections` `AWDeque`. Kept as teaching references only.

## Types

| Type | File | Kind | Backing store | Value semantics |
|---|---|---|---|---|
| `AWNode<T>` | `AWSinglyLinkedList.swift` | `final class` | — | Reference (class) |
| `AWDLLNode<T>` | `AWDoublyLinkedList.swift` | `final class` | — | Reference (class) |
| `AWSinglyLinkedList<T>` | `AWSinglyLinkedList.swift` | `final class` | Pointer-chased nodes | Reference (class) |
| `AWDoublyLinkedList<T>` | `AWDoublyLinkedList.swift` | `final class` | Pointer-chased nodes | Reference (class) |
| `AWQueue<T>` | `AWQueue.swift` | `struct` | `AWSinglyLinkedList` (CoW) | Value ✓ |
| `AWDeque<T>` | `AWDeque.swift` | `struct` | `AWDoublyLinkedList` (CoW) | Value ✓ |
| `AWStack<T>` | `AWStack.swift` | `struct` | `AWSinglyLinkedList` (CoW) | Value ✓ |
| `AWHeapOrder` | `AWHeap.swift` | `enum` | — | Value ✓ |
| `AWHeap<T: Comparable>` | `AWHeap.swift` | `struct` | `[T]` array | Value ✓ |
| `AWMinHeap<T>` | `AWHeap.swift` | typealias for `AWHeap<T>` | — | does not enforce order |
| `AWMaxHeap<T>` | `AWHeap.swift` | typealias for `AWHeap<T>` | — | does not enforce order |

## Key invariants
- `AWQueue`, `AWDeque`, `AWStack` use copy-on-write: `makeUnique()` calls `list.copy()` (O(n) deep copy) before any mutation when reference count > 1.
- `Heap.insert()` returns `Bool`: `false` when capacity is reached (never silently drops).
- `AWSinglyLinkedList` and `AWDoublyLinkedList` conform to `Sequence` and `CustomStringConvertible`.
- `AWQueue`, `AWDeque`, `AWStack`, `AWHeap` conform to `CustomStringConvertible`.
- `MinHeap<T>` / `MaxHeap<T>` are typealiases — they do **not** enforce order at the type system level. Always pass the correct `AWHeapOrder` at construction.
- All `pop` / `extract` methods are marked `@discardableResult` — callers can ignore the return value without a compiler warning.
- `SinglyLinkedList.pushHead` correctly sets `tail` when inserting into an empty list (bug fixed in v2.0).
- `Dequeue` was renamed to `AWDeque` in v2.0 — this is a **breaking API change**. No backward-compat alias exists for the old name.
- **`DLLNode.prev` is `weak var`** — breaks ARC retain cycles between adjacent nodes. Without this, releasing a `AWDoublyLinkedList` (or `AWDeque`) with ≥ 2 nodes would leak the entire node chain because the bidirectional strong references prevent any node's reference count from reaching zero.
- **`Node.next` and `DLLNode.next`/`DLLNode.prev` are `public internal(set)`** — external consumers can traverse nodes by reading these properties, but cannot write to them. Writing from outside the module would silently corrupt `count`, `head`, and `tail` invariants.

## Tests — 41 total, all passing
| Suite | File | Count |
|---|---|---|
| `AWSinglyLinkedListTests` | `AWSinglyLinkedListTests.swift` | 9 (includes empty description test) |
| `AWDoublyLinkedListTests` | `AWDoublyLinkedListTests.swift` | 10 (includes description + ARC leak regression) |
| `AWQueueTests` | `AWQueueTests.swift` | 4 (includes CoW test) |
| `AWDequeTests` | `AWDequeTests.swift` | 5 (includes CoW test) |
| `AWStackTests` | `AWStackTests.swift` | 4 (includes CoW test) |
| `AWHeapTests` | `AWHeapTests.swift` | 9 (includes description format test) |

## Commit history
```
3da10ba refactor: split tests into per-type files
1fc4285 refactor: split source into per-type files
17f5cc1 refactor: add AW prefix to all public types (breaking change)
dd4b8cc docs(context): sync session state — correct latest commit, full history, test count, project overview
125785b docs(context): fix commit hash in CONTEXT.md
0abe389 fix: restrict Node link setters to internal; add missing description tests
c42f57d docs: fix README inaccuracies — stack history, conformance note
e8fdd77 docs(context): fix commit hash placeholder in CONTEXT.md
a2dde0b fix: memory leak in DoublyLinkedList — DLLNode.prev must be weak
d64723f docs: drop misleading 'stable node identity' claim for linked lists
a846af4 docs: move Queue into superseded table, drop verbose justification
c3c7284 docs: clarify Queue is a zero-dependency fallback, swift-collections Deque is preferred
cdd1932 docs(context): fix stale commit, wrong QueueTests count, add missing session history
85a171d docs: add AGENTS.md, .github/CONTEXT.md, Copilot instructions
6f8f5ee docs: clarify swift-collections Deque as a Queue alternative
10c51f7 fix: correctness issues found in CS/DSA audit
07c8fd2 refactor: v2.0 modernization
384caef Verison 1.0.0
0d33be0 First commit
```

## Pending / known limitations
- `MinHeap<T>` / `MaxHeap<T>` typealiases do not prevent constructing a `AWMinHeap` with `order: .max`. A future improvement could be separate concrete types or a phantom-type approach.
- No `buildHeap` init (heapify in O(n)) — all insertions are O(log n) individually.
- `AWHeap` exposes `size` while all other types (`AWQueue`, `AWDeque`, `AWStack`) expose `count` — minor API inconsistency. Changing it is a breaking API change, so deferred.
