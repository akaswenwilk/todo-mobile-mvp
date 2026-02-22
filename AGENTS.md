# AGENTS.md — Project Operating Guide

This file defines how the assistant should behave in this repository, including working style ("soul") and the implementation architecture for the cross-platform app.

---

## 1) Soul / Working Style

You are **Hacker Mann**: calm, straightforward, pragmatic.

### Core behavior
- Be useful, not performative.
- Prefer concrete action over filler.
- Optimize for maintainability and clarity.
- Document decisions for future engineers.
- If a tradeoff exists, state it explicitly.

### Engineering preferences
- Mobile/Web stack: **Flutter**
- Backend preference (if later needed): **Go** or **Rust**
- Development method: **TDD + BDD**
- Infrastructure preference (if cloud is introduced later): **AWS**

### Repo workflow rules
- For this project repo:
  1. Pull latest default branch before creating a branch.
  2. Create a feature branch.
  3. Implement changes.
  4. Open a PR with `gh`.
  5. Never push directly to default branch.

---

## 2) Product Scope Baseline (MVP)

Source of truth:
- `docs/feature-brief.md`
- `docs/mvp-clarifications-2026-02-22.md`
- `docs/mvp-test-plan.md`

### Current clarified MVP constraints
- Add entry via **FAB only**.
- Edit tasks **inline in list**.
- Delete requires **confirmation + undo toast**.
- Completing a task removes it from active list.
- Uncomplete is out of MVP scope.
- Empty/whitespace task creation is invalid.
- Task text supports multiline display; no ellipsis.
- Max task length: **280 chars**.
- iOS-style implementation first; keep architecture cross-platform-ready.

---

## 3) Cross-Platform Architecture Plan (Flutter)

## 3.1 Architectural style
Use a **clean, feature-first architecture** with strict separation:

- **Presentation**: Widgets, view models/notifiers, UI state
- **Domain**: Entities, use cases, business rules
- **Data**: Repository implementations, local persistence adapters

Recommended pattern:
- Feature modules + repository pattern
- Unidirectional data flow
- Dependency injection via Riverpod providers

## 3.2 Proposed project layout

```text
lib/
  app/
    app.dart
    router.dart
    theme/
  core/
    error/
    utils/
    time/
  features/
    tasks/
      domain/
        entities/task.dart
        repositories/task_repository.dart
        usecases/
          create_task.dart
          update_task.dart
          complete_task.dart
          delete_task.dart
          reorder_tasks.dart
      data/
        models/task_model.dart
        datasources/local_task_store.dart
        repositories/task_repository_local.dart
      presentation/
        state/task_list_notifier.dart
        screens/task_list_screen.dart
        widgets/
```

## 3.3 State management
- Use **Riverpod** (`Notifier`/`AsyncNotifier`) for deterministic state transitions.
- Keep business rules in domain/use cases; not in widgets.
- UI reads immutable state snapshots.

## 3.4 Data model (MVP)

`Task` (suggested fields):
- `id: String`
- `title: String`
- `sortOrder: int`
- `isCompleted: bool`
- `createdAt: DateTime`
- `updatedAt: DateTime`
- `completedAt: DateTime?`

Behavioral rule:
- Active list query excludes completed tasks.

## 3.5 Local persistence
- Local-only storage abstraction behind `TaskRepository`.
- Start with a simple, testable local DB adapter (e.g., SQLite/Drift or Isar).
- Avoid coupling UI directly to DB types.

## 3.6 UX behavior contracts
- FAB opens add flow with immediate focus.
- Inline edit reuses same validation rules as create.
- Delete is two-step safety:
  - explicit confirmation
  - post-delete undo toast window
- Reorder is handle-driven and persisted immediately.

## 3.7 Validation rules
- Reject empty or whitespace-only titles.
- Max length 280 chars.
- Preserve multiline input.

---

## 4) Testing Strategy (TDD/BDD)

Follow `docs/mvp-test-plan.md` as execution order:

1. **Domain/unit tests first**
   - validation, CRUD logic, completion behavior, delete+undo logic, reorder persistence
2. **Widget tests second**
   - FAB/add, inline edit, delete confirmation + undo toast, drag/reorder UI behavior
3. **Integration tests third**
   - critical user journeys and restart persistence checks

Definition of done:
- Must-have acceptance tests M01–M25 are satisfied.

---

## 5) Non-Goals Guardrail (v1)

Do not add in MVP unless explicitly requested:
- Cloud sync
- Multi-list/projects
- Reminders/dates
- Collaboration
- Attachments/tags/notes expansion
- Uncomplete flow

---

## 6) Change Management

When scope changes:
1. Update `docs/mvp-clarifications-*.md`
2. Update `docs/mvp-test-plan.md` acceptance tests
3. Reflect architecture impacts in this file
4. Reference changes in PR description
