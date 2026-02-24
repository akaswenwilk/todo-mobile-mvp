# QA Checklist (PR-05 scope)

Each QA item below has at least one Playwright E2E test in `e2e/task-list.spec.ts`.

1. **App shell loads with empty state**
   - E2E: `shows shell with empty state on first load`

2. **Add task via FAB flow**
   - E2E: `creates a task from the FAB add flow`

3. **Inline edit updates an existing task**
   - E2E: `edits an existing task inline`

4. **Complete action removes a task from active list**
   - E2E: `completes a task and removes it from active list`

5. **Reorder tasks using drag handle interaction**
   - E2E: `reorders tasks with drag handle interaction`

6. **Delete safety flow (confirm/cancel + undo)**
   - E2E: `delete flow supports cancel and undo`
