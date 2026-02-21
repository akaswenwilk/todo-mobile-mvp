# iOS + Android Variant Notes — Todo Mobile MVP

## Product Consistency Rule
Shared IA and behavior. Native controls and motion per platform.

---

## Shared Across Platforms
- One-list model only
- Task CRUD
- Reorder by drag handle
- Completion is reversible and separate from deletion
- Local-only persistence
- Dark-first palette and hierarchy

---

## iOS Variant (Cupertino-aligned)

### Navigation
- Large title treatment (`Today`) optional at top
- Native-feeling back/gesture handling where applicable

### Components
- SF Symbols for icons
- Rounded row surfaces with subtle blur/elevation
- iOS-style context menus and swipe actions

### Motion
- Softer spring-like transitions
- Subtle haptic on complete, reorder drop, and delete confirm

### Keyboard / Input
- Return key labeled `Done`
- Fast inline input focus and dismiss behaviors

---

## Android Variant (Material 3 aligned)

### Navigation
- Top app bar with title
- Respect Android system back and edge gestures

### Components
- Material icons
- Surface containers with tonal elevation
- Optional FAB-style `Add` if testing supports higher speed

### Motion
- Slightly more pronounced state transitions
- Ripple feedback on taps

### Keyboard / Input
- IME action `Done`
- Strong focus states and clear touch feedback

---

## Platform-Specific Gestures
- **Reorder:** handle-based drag on both (avoid accidental full-row drag)
- **Delete:**
  - iOS: swipe action + confirm/undo
  - Android: swipe/menu with clear destructive affordance
- **Complete:** single tap on leading control on both

---

## QA Checklist for Design Parity
1. Can user add a task in <10 seconds on both platforms?
2. Are complete and delete clearly different actions?
3. Does reorder feel stable and predictable?
4. Are touch targets >=44pt/48dp equivalent?
5. Are contrast and type legibility solid in dark mode?

---

## Prototype Review Focus
- Capture speed
- Clarity of completion vs deletion
- Reorder confidence
- Perceived calmness / low cognitive load
