# Implementation Plan — Todo Mobile MVP (iOS-first, cross-platform-ready)

Date: 2026-02-22

This plan turns the clarified MVP scope into deliverable engineering phases with explicit testing gates.

## 0) Scope Anchors

- Use scope + behavior from:
  - `docs/mvp-clarifications-2026-02-22.md`
  - `docs/mvp-test-plan.md`
  - `AGENTS.md`

Key constraints:
- FAB-only add entry
- Inline edit in list
- Complete hides from active list (no uncomplete in MVP)
- Delete requires confirm + undo
- Multiline task text, max 280 chars
- Local-only persistence

---

## 1) Technical Decisions (lock before coding)

1. **Flutter app skeleton** with feature-first folder structure.
2. **State management:** Riverpod Notifier-based flow.
3. **Persistence:** local DB abstraction behind repository (Drift preferred for deterministic tests + migrations).
4. **Theme/UI:** iOS-first dark style using Cupertino-aligned components where appropriate.
5. **Test pyramid:** unit > widget > integration, per MVP plan.

Output: architecture skeleton committed with no feature behavior yet.

---

## 2) Delivery Phases

## Phase A — Bootstrap + Foundations

### Build tasks
- Create Flutter app scaffold and package structure.
- Setup app theme tokens from wireframe spec.
- Setup dependency injection/providers.
- Add repository interface + local store contract (stub implementation).

### Tests
- Smoke test: app launches (`M01`).
- Theme/app shell widget tests (`M02`, `M03`).

### Exit criteria
- CI runs analyze + unit/widget baseline.
- App launches to empty shell without runtime errors.

---

## Phase B — Domain Rules (TDD first)

### Build tasks
- Implement `Task` entity + validators.
- Implement use cases:
  - CreateTask
  - UpdateTask
  - CompleteTask
  - DeleteTask (with undo window model)
  - ReorderTasks
- Implement active-list filtering (exclude completed).

### Tests (unit)
- Validation rules: empty/whitespace, max length, multiline support (`M07`–`M10`, `M13`).
- Completion behavior (`M14`, `M15`, `M16`).
- Reorder behavior (`M22`, `M23`).
- Delete lifecycle rules (`M17`–`M21`).

### Exit criteria
- All domain unit tests green.
- No UI-layer business logic duplication.

---

## Phase C — Local Persistence Adapter

### Build tasks
- Implement local repository adapter (Drift) and mapping layer.
- Persist create/edit/complete/delete/reorder.
- Ensure deterministic sortOrder behavior.

### Tests
- Repository contract tests for CRUD + reorder + completion persistence (`M06`, `M12`, `M15`, `M23`).
- Restart simulation tests for persistence guarantees.

### Exit criteria
- Persistence contract suite green.
- Local-only operation verified (no network dependency).

---

## Phase D — Core UI Flows (iOS-style MVP)

### Build tasks
- Main list screen with FAB.
- Add task flow (focus + keyboard + save).
- Inline edit in row.
- Complete action (remove from active list).
- Reorder via drag handle.

### Tests (widget)
- FAB open/focus/save (`M04`, `M05`).
- Inline edit semantics (`M11`, `M12`, `M13`).
- Multiline rendering no ellipsis (`M09`).
- Complete hides item (`M14`).
- Reorder interaction (`M22`).

### Exit criteria
- Core CRUD/complete/reorder UX stable in widget tests.

---

## Phase E — Delete Safety UX

### Build tasks
- Implement delete affordance (swipe/menu).
- Add confirmation modal.
- Add undo toast and expiry behavior.

### Tests
- Confirm cancel path (`M18`).
- Confirm delete path (`M19`).
- Undo restore + timeout permanence (`M20`, `M21`).

### Exit criteria
- Both safety layers required by MVP are functional.

---

## Phase F — Integration + Hardening

### Build tasks
- Wire end-to-end flows across persistence + UI.
- Stabilize performance and edge cases (long lists, multiline rows).

### Tests (integration)
- First-run empty state + first add.
- Add multiline + restart persistence.
- Inline edit + restart persistence.
- Delete confirm + undo and timeout path.
- Reorder + restart persistence.
- Complete + restart persistence.
- Full journey add → edit → reorder → complete (`M24`).
- Offline/local-only guarantee (`M25`).

### Exit criteria
- Must-have suite M01–M25 fully green.
- No P0/P1 defects.

---

## 3) PR Slicing Plan

Suggested incremental PRs:
1. **PR-01:** App scaffold + architecture skeleton + baseline tests
2. **PR-02:** Domain entities/use cases + unit tests
3. **PR-03:** Local persistence adapter + repository contract tests
4. **PR-04:** Add + inline edit + complete + widget tests
5. **PR-05:** Reorder + delete confirm/undo + widget tests
6. **PR-06:** Integration tests + bugfix hardening

Each PR must include:
- Updated tests
- Scope note referencing MVP clarification doc
- Screenshots/video for UI-changing PRs

---

## 4) CI Gate Plan

Required checks on every PR:
- `flutter analyze`
- `flutter test` (unit + widget)
- integration test job (for relevant branches/stages)

Release-ready gate:
- All M01–M25 passing
- Green CI across required jobs

---

## 5) Risks & Mitigations

1. **Drag/reorder flakiness**
   - Mitigate with deterministic sortOrder strategy + focused widget tests.

2. **Delete confirm + undo complexity**
   - Model state transition explicitly in domain and test lifecycle thoroughly.

3. **Multiline row layout instability**
   - Add golden/widget snapshot checks for short + long multiline tasks.

4. **Scope creep**
   - Enforce non-goals listed in `AGENTS.md` and clarification doc.
