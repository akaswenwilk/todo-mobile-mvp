import { expect, test, type Page } from '@playwright/test';

async function enableAccessibilityIfPrompted(page: Page) {
  const hasPlaceholder = await page
    .waitForSelector('flt-semantics-placeholder', { timeout: 20_000 })
    .then(() => true)
    .catch(() => false);

  if (!hasPlaceholder) return;

  await page.evaluate(() => {
    const placeholder = document.querySelector('flt-semantics-placeholder');
    if (!placeholder) return;

    placeholder.dispatchEvent(
      new MouseEvent('click', {
        bubbles: true,
        cancelable: true,
        view: window,
      }),
    );
  });

  await expect(page.getByRole('button', { name: 'Add task' })).toBeVisible({
    timeout: 15_000,
  });
}

async function addTask(page: Page, title: string) {
  await page.getByRole('button', { name: 'Add task' }).click();
  await page.getByRole('textbox', { name: 'Task title' }).fill(title);
  await page.getByRole('button', { name: 'Add' }).click();
  await expect(page.getByRole('textbox', { name: 'Task title' })).toBeHidden();
}

async function openInlineEditor(page: Page, title: string) {
  const editInput = page.getByRole('textbox', { name: 'Edit task title' });

  for (let attempt = 0; attempt < 3; attempt++) {
    const taskRow = page.getByRole('group', { name: title });
    await taskRow
      .click({ position: { x: 280, y: 24 }, timeout: 1_500 })
      .catch(() => undefined);

    const opened = await editInput
      .isVisible({ timeout: 1_500 })
      .catch(() => false);

    if (opened) {
      await expect(editInput).toBeVisible();
      return;
    }
  }

  await expect(editInput).toBeVisible();
}

async function replaceTextInInlineEditor(page: Page, newText: string) {
  const editInput = page.getByRole('textbox', { name: 'Edit task title' });
  await editInput.click();
  await editInput.press('Control+A');
  await editInput.type(newText);
}

async function dragTaskBelow(page: Page, taskTitle: string, belowTaskTitle: string) {
  const source = page.getByRole('group', { name: taskTitle });
  const target = page.getByRole('group', { name: belowTaskTitle });

  const sourceBox = await source.boundingBox();
  const targetBox = await target.boundingBox();

  if (!sourceBox || !targetBox) {
    throw new Error('Could not resolve task row geometry for drag operation.');
  }

  await page.mouse.move(sourceBox.x + sourceBox.width - 20, sourceBox.y + sourceBox.height / 2);
  await page.mouse.down();
  await page.mouse.move(targetBox.x + targetBox.width - 20, targetBox.y + targetBox.height + 12, {
    steps: 10,
  });
  await page.mouse.up();
}

test.describe('Todo MVP - Flutter web e2e', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    await enableAccessibilityIfPrompted(page);
  });

  test('shows shell with empty state on first load', async ({ page }) => {
    await expect(page.getByText('Today')).toBeVisible();
    await expect(
      page.getByText('Nothing here yet\nAdd your first task to clear your mind.'),
    ).toBeVisible();
    await expect(page.getByRole('button', { name: 'Add task' })).toBeVisible();
  });

  test('creates a task from the FAB add flow', async ({ page }) => {
    await addTask(page, 'Ship MVP changelog');

    await expect(
      page.getByRole('group', { name: 'Ship MVP changelog' }),
    ).toBeVisible();
    await expect(
      page.getByText('Nothing here yet\nAdd your first task to clear your mind.'),
    ).toBeHidden();
  });

  test('edits an existing task inline', async ({ page }) => {
    await addTask(page, 'Draft release notes');

    await openInlineEditor(page, 'Draft release notes');
    await replaceTextInInlineEditor(page, 'Draft and review release notes');
    await page.getByRole('button', { name: 'Save task edits' }).click();
    await expect(
      page.getByRole('textbox', { name: 'Edit task title' }),
    ).toBeHidden();

    await expect(
      page.getByRole('group', { name: 'Draft and review release notes' }),
    ).toBeVisible();
    await expect(
      page.getByRole('group', { name: 'Draft release notes' }),
    ).toBeHidden();
  });

  test('completes a task and removes it from active list', async ({ page }) => {
    await addTask(page, 'Archive old sprint board');

    await page.getByRole('button', { name: 'Complete task' }).click();

    await expect(
      page.getByRole('group', { name: 'Archive old sprint board' }),
    ).toBeHidden();
    await expect(
      page.getByText('Nothing here yet\nAdd your first task to clear your mind.'),
    ).toBeVisible();
  });

  test('reorders tasks with drag handle interaction', async ({ page }) => {
    await addTask(page, 'Task A');
    await addTask(page, 'Task B');

    await dragTaskBelow(page, 'Task A', 'Task B');

    const taskRows = page.locator('flt-semantics[role="group"][aria-label]');
    await expect(taskRows.nth(0)).toHaveAttribute('aria-label', 'Task B');
    await expect(taskRows.nth(1)).toHaveAttribute('aria-label', 'Task A');
  });

  test('delete flow supports cancel and undo', async ({ page }) => {
    await addTask(page, 'Delete me maybe');

    const row = page.getByRole('group', { name: 'Delete me maybe' });

    await row.getByRole('button', { name: 'Delete task' }).click();
    await expect(page.getByRole('alertdialog')).toBeVisible();
    await page.getByRole('button', { name: 'Cancel' }).click();
    await expect(row).toBeVisible();

    await row.getByRole('button', { name: 'Delete task' }).click();
    await page.getByRole('button', { name: 'Delete' }).click();

    await expect(row).toBeHidden();
    await page.getByRole('button', { name: 'Undo' }).click();
    await expect(page.getByRole('group', { name: 'Delete me maybe' })).toBeVisible();
  });
});
