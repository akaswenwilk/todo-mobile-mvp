# Wireframe Spec — Todo Mobile MVP (Dark-First)

## Frame Setup
- **iOS frame:** 390 × 844 (iPhone 14/15 base)
- **Android frame:** 412 × 915 (Pixel baseline)
- **Grid:** 4pt spacing system
- **Safe horizontal padding:** 16pt
- **Primary corner radius:** 12

## Visual Foundation (Dark)
- App background: `#0B0D12`
- Surface: `#121723`
- Surface elevated: `#171E2B`
- Primary text: `#F4F7FF`
- Secondary text: `#9AA6BF`
- Accent: `#6EA8FF`
- Success/completed: `#6D9B7A`
- Danger/delete: `#FF6B6B`

## Typography
- Title / screen: 28 semibold
- Task text: 16 medium
- Meta / helper: 13 regular
- CTA text: 15 semibold

---

## S1 — Main List Screen

### Layout
1. **Top bar** (height ~56):
   - Left: "Today" title
   - Right: subtle overflow icon
2. **Task list area**:
   - Vertical list of task rows
   - 10–12pt gap between rows
3. **Sticky add control at bottom**:
   - Full-width button / input trigger: `+ Add task`
   - Positioned for thumb reach

### Task Row (default)
- Container: 56–64pt height, surface elevated, radius 12
- Left: completion control (unticked circle)
- Center: task title
- Right: drag handle

### Interaction hints
- Swipe left/right reveals edit/delete (or long-press menu)
- Drag handle enters reorder mode

---

## S2 — Add Task State (Inline)

### Trigger
- Tap `+ Add task`

### UI
- Replace add bar with focused text input
- Keyboard opens instantly
- Placeholder: `What needs to get done?`
- Confirm via keyboard `Done` or inline check action

### Constraints
- Single-line task title in MVP
- Must complete in <10 seconds

---

## S3 — Edit Task State

### Trigger
- Tap task text or edit action

### UI
- Same visual model as Add state (consistency)
- Pre-filled task text
- Save on submit / blur

---

## S4 — Empty State

### UI
- Centered icon (minimal)
- Headline: `Nothing here yet`
- Subtext: `Add your first task to clear your mind.`
- Primary action: `+ Add task`

### Goal
- Remove ambiguity instantly

---

## S5 — State Variants

### Completed state
- Completion control filled
- Task text reduced emphasis + optional strike
- Remains visible (not deleted)

### Dragging state
- Active row lifts (elevation + slight scale)
- Placeholder gap appears at destination

### Delete confirmation
- Destructive action requires secondary confirmation or undo toast

---

## Micro-Interactions
- Completion tap: 120–180ms ease-out
- Drag start: 100ms lift transition
- Add task insertion: 150ms fade/slide
- Delete undo toast: 3–5s visible

## Accessibility Targets
- Touch targets >= 44x44
- Text contrast WCAG AA minimum
- Completion and deletion must be visually distinct (shape + color, not color only)
