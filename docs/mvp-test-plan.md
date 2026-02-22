# MVP Test Plan — Must-Have Acceptance + TDD Order

Date: 2026-02-22  
Scope baseline: `docs/mvp-clarifications-2026-02-22.md` (iOS-style first, FAB-only add, inline edit, complete hides task, delete requires confirm + undo).

## 1) Must-Have MVP Acceptance Tests (Top 25)

### Core app shell
- **M01** App launches to main list screen without crash.
- **M02** Dark-first theme is applied consistently on first launch.
- **M03** FAB is visible; bottom status strip is not present.

### Add task (FAB flow)
- **M04** Tapping FAB opens focused add input immediately (keyboard up).
- **M05** Submitting valid text creates a task and returns to list.
- **M06** Newly created task persists after app restart.
- **M07** Empty input cannot create a task.
- **M08** Whitespace-only input cannot create a task.
- **M09** Task text supports multiline display (no ellipsis).
- **M10** Task text max length is enforced at 280 chars.

### Edit task (inline)
- **M11** Editing is inline in the list with prefilled value.
- **M12** Inline edit save updates text and persists after restart.
- **M13** Inline edit cannot save empty/whitespace-only values.

### Complete task (one-way MVP behavior)
- **M14** Tapping complete marks task complete and removes it from active list immediately.
- **M15** Completed task remains removed after restart.
- **M16** No uncomplete action is exposed in MVP UI.

### Delete task (requires confirm + undo)
- **M17** Delete action requires confirmation before removal.
- **M18** Canceling confirmation keeps task unchanged.
- **M19** Confirming delete removes task from active list.
- **M20** Undo toast appears after delete and restores task when tapped.
- **M21** If undo window expires, deletion remains permanent.

### Reorder / priority
- **M22** Drag handle starts reorder; drop updates item position.
- **M23** Reordered list persists after app restart.

### End-to-end behavior / local-first guarantees
- **M24** End-to-end: add → edit inline → reorder → complete works as expected.
- **M25** App behavior is fully local/offline for MVP task operations.

---

## 2) TDD Execution Order (Unit → Widget → Integration)

### Phase 0 — Test harness + fixtures
1. Setup test data factories (`TaskFactory`) and deterministic clock/id providers.
2. Add fake local repository and persistence test doubles.
3. Define shared acceptance fixture tasks (short, multiline, max length).

### Phase 1 — Domain/Unit tests (fastest feedback)
Implement first to lock business rules.

- Task validation rules:
  - reject empty/whitespace
  - max length 280
  - preserve multiline text
- Use-case behaviors:
  - create task
  - update task text (inline edit semantics)
  - complete task (hide from active list)
  - delete task (confirm/undo lifecycle model)
  - reorder tasks
- Persistence contract tests:
  - CRUD/reorder/complete/delete survive reload

### Phase 2 — Widget tests (UI behavior in isolation)
Implement next for interaction confidence without full device runtime.

- Main screen renders (dark theme, FAB visible, no bottom status strip)
- FAB opens add input with focus
- Inline edit row behavior
- Validation messaging/disabled save behavior
- Complete interaction removes item from active list UI
- Delete confirmation + undo toast UI lifecycle
- Drag handle reorder behavior

### Phase 3 — Integration/E2E tests (critical user journeys)
Implement after unit+widget pass; keep to essential journeys.

1. First-run empty state + create first task via FAB
2. Add multiline task, restart app, verify persistence
3. Inline edit existing task, restart app, verify update
4. Delete with confirm, then undo restore
5. Delete with confirm, allow undo timeout, verify permanence
6. Reorder tasks and verify persisted order after restart
7. Complete task and verify it disappears from active list after restart
8. Full journey: add → edit → reorder → complete (no network dependency)

---

## 3) Definition of Done for MVP testing

- All **M01–M25** pass on iOS-style MVP build.
- Unit + widget suite green in CI.
- Integration suite green on at least one iOS simulator target.
- No open P0/P1 defects on add/edit/delete/complete/reorder flows.
