# User Flows — Todo Mobile MVP

## Flow A — Open and Understand Instantly
1. User opens app
2. Sees single list view + obvious Add Task control
3. If empty: simple empty state with one clear CTA

**Success criterion:** user understands what to do in <2 seconds.

---

## Flow B — Create Task in <10 Seconds
1. Tap `+ Add task`
2. Keyboard opens immediately with focused input
3. Type task title
4. Tap `Done` (or keyboard submit)
5. Task appears in list immediately

**Performance target:** perceived instant response.

---

## Flow C — Reorder Tasks by Priority
1. Press/hold drag handle
2. Drag task to desired position
3. Release to confirm new order
4. New order persists locally

**Mental model:** higher in list = more important now.

---

## Flow D — Complete Task (Not Delete)
1. Tap completion control
2. Task moves to completed visual state
3. Task remains available unless explicitly deleted

**Rule:** completion must always be reversible.

---

## Flow E — Edit Task
1. Tap task (or edit action)
2. Update task text
3. Save (or auto-save on submit)

---

## Flow F — Delete Task (Intentional)
1. Invoke delete action (swipe/menu)
2. Confirm or allow undo
3. Task is removed permanently

**Rule:** deletion requires stronger intent than completion.
