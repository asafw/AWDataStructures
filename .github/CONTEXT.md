# AWDataStructures — Project State

> Authoritative context document for AI-assisted development.
> Update at the end of every session that makes code changes.

## Repo
- Path: `~/Desktop/asafw/AWDataStructures/`
- GitHub: `asafw/AWDataStructures` (public)
- Latest commit: `6f8f5ee` — docs: clarify swift-collections Deque as a Queue alternative
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

## Types

| Type | Kind | Backing store | Value semantics |
|---|---|---|---|
| `SinglyLinkedList<T>` | `final class` | Pointer-chased nodes | Reference (class) |
| `DoublyLinkedList<T>` | `final class` | Pointer-chased nodes | Reference (class) |
| `Queue<T>` | `struct` | `SinglyLinkedList` (CoW) | Value ✓ |
| `Deque<T>` | `struct` | `DoublyLinkedList` (CoW) | Value ✓ |
| `Stack<T>` | `struct` | `SinglyLinkedList` (CoW) | Value ✓ |
| `Heap<T: Comparable>` | `struct` | `[T]` array | Value ✓ |
| `HeapOrder` | `enum` | — | Value ✓ |
| `MinHeap<T>` | typealias for `Heap<T>` | — | does not enforce order |
| `MaxHeap<T>` | typealias for `Heap<T>` | — | does not enforce order |

## Key invariants
- `Queue`, `Deque`, `Stack` use copy-on-write: `makeUnique()` calls `list.copy()` (O(n) deep copy) before any mutation when reference count > 1.
- `Heap.insert()` returns `Bool`: `false` when capacity is reached (never silently drops).
- `SinglyLinkedList` and `DoublyLinkedList` conform to `Sequence` and `CustomStringConvertible`.
- `Queue`, `Deque`, `Stack`, `Heap` conform to `CustomStringConvertible`.
- `MinHeap<T>` / `MaxHeap<T>` are typealiases — they do **not** enforce order at the type system level. Always pass the correct `HeapOrder` at construction.

## Tests — 37 total, all passing
| Suite | Count |
|---|---|
| `SinglyLinkedListTests` | 8 |
| `DoublyLinkedListTests` | 8 |
| `QueueTests` | 5 (includes CoW test) |
| `DequeTests` | 5 (includes CoW test) |
| `StackTests` | 4 (includes CoW test) |
| `HeapTests` | 8 |

## Commit history
```
6f8f5ee docs: clarify swift-collections Deque as a Queue alternative
10c51f7 fix: correctness issues found in CS/DSA audit
07c8fd2 refactor: v2.0 modernization
384caef Verison 1.0.0
0d33be0 First commit
```

## Pending / known limitations
- `MinHeap<T>` / `MaxHeap<T>` typealiases do not prevent constructing a `MinHeap` with `order: .max`. A future improvement could be separate concrete types or a phantom-type approach.
- No `buildHeap` init (heapify in O(n)) — all insertions are O(log n) individually.
