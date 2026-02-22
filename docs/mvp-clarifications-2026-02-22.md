# MVP Clarifications — 2026-02-22

This document captures scope clarifications from review Q&A.

## Q&A Log

1. **Q:** Add task UI pattern: FAB vs full-width add bar?
   - **A:** Use **FAB only** for MVP.

2. **Q:** Add/Edit interaction model?
   - **A:** **Edit inline in list**.

3. **Q:** Delete safety pattern: confirmation vs undo toast?
   - **A:** **Both are required** for MVP.

4. **Q:** Completed task behavior?
   - **A:** Completed tasks should **disappear from the list**.
   - **Note:** Reversing completion (uncomplete) is **out of scope**.

5. **Q:** Task text constraints?
   - **A:**
     - Empty/whitespace-only input must **not** create tasks.
     - No ellipsis truncation; task text should support **multiline** display.
     - Max length: **280 characters** (chosen implementation constraint).

6. **Q:** Include bottom status strip/card from mocks?
   - **A:** **Omit** from MVP.

7. **Q:** First implementation style target?
   - **A:** Start with **iOS-style MVP first**.
