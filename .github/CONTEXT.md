# AWDataStructures — Project State

> Authoritative context document for AI-assisted development.
> Update at the end of every session that makes code changes.

## Repo
- Path: `~/Desktop/asafw/AWDataStructures/`
- GitHub: `asafw/AWDataStructures` (public)
- Latest commit: `beb6c17` — test: audit — DLL empty description, DLL popTail clears head+tail, Deque nil-on-empty pops
- Branch: `master`

## Build Commands
```bash
swift build
swift test
```

## CI
- Workflow: `.github/workflows/ci.yml`
- Triggers: push and pull_request on `master`
- Matrix: `macos-latest`, `ubuntu-latest`
- Steps: `swift build` → `swift test`

## Package
- `swift-tools-version`: 5.9
- No external dependencies
- No platform restriction — pure Swift stdlib, builds on iOS, macOS, Linux, Windows, WASM
- Zero imports in source (no Foundation, no Darwin, no platform frameworks)

## Relevance (2026)
All four higher-level types are superseded by better alternatives:

| Type | Superseded by |
|---|---|
| `AWQueue<T>` | `swift-collections` `Deque<T>` — superset, better cache performance |
| `AWDeque<T>` | `swift-collections` `Deque<T>` — better cache locality |
| `AWStack<T>` | `Array` + `.append()` / `.popLast()` — idiomatic Swift |
| `AWHeap<T>` | `swift-collections` `Heap<T>` — richer API |

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
| `AWHeapOrder` | `AWHeap.swift` | `enum: Equatable` | — | Value ✓ |
| `AWHeap<T: Comparable>` | `AWHeap.swift` | `struct` | `[T]` array | Value ✓ |
| `AWMinHeap<T>` | `AWHeap.swift` | typealias for `AWHeap<T>` | — | does not enforce order |
| `AWMaxHeap<T>` | `AWHeap.swift` | typealias for `AWHeap<T>` | — | does not enforce order |

## Key invariants
- `AWQueue`, `AWDeque`, `AWStack` use copy-on-write: `makeUnique()` calls `list.copy()` (O(n) deep copy) before any mutation when reference count > 1.
- `AWHeap.insert()` returns `Bool`: `false` when capacity is reached (never silently drops).
- `AWSinglyLinkedList` and `AWDoublyLinkedList` conform to `Sequence` and `CustomStringConvertible`.
- `AWQueue`, `AWDeque`, `AWStack`, `AWHeap` conform to `CustomStringConvertible`.
- `AWQueue`, `AWDeque`, `AWStack`, `AWHeap` conform to `Equatable` where `T: Equatable` (conditional conformance).
- `AWMinHeap<T>` / `AWMaxHeap<T>` are typealiases — they do **not** enforce order at the type system level. Always pass the correct `AWHeapOrder` at construction.
- All `pop` / `extract` / `dequeue` methods are marked `@discardableResult` — callers can ignore the return value without a compiler warning.
- `AWSinglyLinkedList.pushHead` correctly sets `tail` when inserting into an empty list (bug fixed in v2.0).
- `Dequeue` was renamed to `AWDeque` in v2.0 — this is a **breaking API change**. No backward-compat alias exists for the old name.
- **`AWDLLNode.prev` is `weak var`** — breaks ARC retain cycles between adjacent nodes. Without this, releasing an `AWDoublyLinkedList` (or `AWDeque`) with ≥ 2 nodes would leak the entire node chain because the bidirectional strong references prevent any node's reference count from reaching zero.
- **`AWNode.next` and `AWDLLNode.next`/`AWDLLNode.prev` are `public internal(set)`** — external consumers can traverse nodes by reading these properties, but cannot write to them. Writing from outside the module would silently corrupt `count`, `head`, and `tail` invariants.

## Tests — 52 total, all passing
| Suite | File | Count |
|---|---|---|
| `AWSinglyLinkedListTests` | `AWSinglyLinkedListTests.swift` | 9 (includes empty description test) |
| `AWDoublyLinkedListTests` | `AWDoublyLinkedListTests.swift` | 12 (includes empty description, popTail clears head+tail, ARC leak regression) |
| `AWQueueTests` | `AWQueueTests.swift` | 6 (includes CoW, description, equality tests) |
| `AWDequeTests` | `AWDequeTests.swift` | 9 (includes CoW, nil-on-empty pops, description, equality tests) |
| `AWStackTests` | `AWStackTests.swift` | 6 (includes CoW, description, equality tests) |
| `AWHeapTests` | `AWHeapTests.swift` | 10 (includes description format, equality tests) |

## Commit history
```
beb6c17 test: audit — DLL empty description, DLL popTail clears head+tail, Deque nil-on-empty pops
3764d95 fix: AWHeapOrder explicit Equatable, AWHeap equality note, fix doc comment typo in AWSinglyLinkedList
5b30cd8 feat: audit fixes — Equatable conformance, description tests, remove obsolete Linux test files
f94ccc2 ci: add GitHub Actions workflow (macOS + Ubuntu)
a28ecdd docs(context): fix stale type names and missing commits in context
bd0227c docs(context): fix commit hash after test file split
3da10ba refactor: split tests into per-type files
976fa05 docs(context): fix commit hash after file split
1fc4285 refactor: split source into per-type files
9ea7946 docs: add DoublyLinkedList usage example; fix stale type names in table
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
- `AWMinHeap<T>` / `AWMaxHeap<T>` typealiases do not prevent constructing an `AWMinHeap` with `order: .max`. A future improvement could be separate concrete types or a phantom-type approach.
- No `buildHeap` init (heapify in O(n)) — all insertions are O(log n) individually.
- `AWHeap` exposes `size` while all other types (`AWQueue`, `AWDeque`, `AWStack`) expose `count` — minor API inconsistency. Changing it is a breaking API change, so deferred.
