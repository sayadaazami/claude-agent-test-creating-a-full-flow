---
description: Show the task board (compact Kanban view)
argument-hint: (optional: filter by agent name)
---

Show the task board from `docs/tasks.md`.

Steps:

1. Read `docs/tasks.md`.
2. If `$ARGUMENTS` is provided, filter tasks where `owner: $ARGUMENTS` OR `reviewer: $ARGUMENTS`.
3. Render a compact view:

```
BACKLOG (<count>)
  [TASK-XXX] title — owner — phase
  ...

TODO (<count>)
  [TASK-XXX] title — owner — phase
  ...

DOING (<count>)
  [TASK-XXX] title — owner — started <date>
  ...

REVIEW (<count>)
  [TASK-XXX] title — owner → reviewer — rev <N>
  ...

DONE (last 5)
  [TASK-XXX] title — owner — completed <date>
  ...
```

End with a one-line summary: total tasks, % done, current phase.

Link to [tasks.md](docs/tasks.md) and [STATUS.md](docs/STATUS.md).
