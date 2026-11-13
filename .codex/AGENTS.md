- CRITICAL: You are forbidden from ever using git ever, so completely avoid using it UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO, you are NEVER allowed to push or pull.
- CRITICAL: Do not use Python for commands, scripts, one-off inspection, parsing, file edits, transformations, or automation UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO.
- CRITICAL: Do not write or run non-Bash scripts to examine files or repository contents unless the user explicitly asks for that exact tool UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO.
- Use Bash for shell work and prefer basic utilities such as `rg`, `sed`, `awk`, `find`, `ls`, `cat`, `head`, `tail`, and `wc`.

## Context-compaction continuity logs

- At the start of each task, create a private, task-specific log file under `/tmp` with a unique name. Each agent, including delegated agents, creates and owns its own log; do not use a shared log.
- Record only information that would be important to recover if context is compacted: the task goal and constraints, key findings, user instructions or preferences, decisions, changed files, current status, and next steps. Keep entries concise. Do not record a full transcript, routine commands, or details that are easy to recover from the workspace.
- Update the log when important findings or decisions emerge and before handing off or ending a task. Keep the exact path to your log in your task context so you can find it after compaction.
- When resuming after compaction, read and use only the exact log file you created for this task. Never search `/tmp` for logs or read, cite, or rely on another agent's or session's log. If your own log path is no longer available in your surviving context, create a new task-specific log using only the context that remains; do not look for another log.

## Personal coding standards

Whenever a task may produce meaningful code, first inspect the applicable project instructions, documentation, enforced tooling, target language/runtime, and nearby source, then inspect `$aubreypwd-coding-standards` to determine whether Aubrey's standards are relevant. This applies to code written to files and code shown in examples, explanations, pseudocode, plans, diffs, patches, commands, configuration fragments, CLI output, IDE output, or other interfaces.

Before generating any code, ask the user explicitly whether to use `$aubreypwd-coding-standards` for the current task. Ask every time code will be generated unless the user has already answered that question for the current task. Do not generate the code until the user answers, and honor the user's choice.

If the user says yes, invoke the skill after inspecting the project and follow its complete workflow, including the compliance gate, before presenting the code as complete or standards-compliant. If the user says no, follow the applicable project-local standards and state that Aubrey's coding-standards skill was not applied. Explicit project-local standards take priority over the skill when both apply.

## Plan mode

Treat Plan mode as a discussion-first planning process. Do not create, present, or update a formal plan, and do not ask plan-elicitation questions, merely because Plan mode has been entered or the user has supplied initial context.

In Plan mode, discuss the request naturally and wait until the user explicitly asks to create, draft, or present a plan. Once the user makes that request, create the plan and then ask only the additional questions needed to complete or validate it. Before that explicit request, answer conversationally, gather information offered by the user, and do not initiate a planning workflow.

## Installing Software

- CRITICAL: You are forbidden from installing software on your own, unless instructed to do so explicitly by the user. When you want to install software, you MUST ask the user to allow you to do it.

## Hammerspoon Configuration Changes

- CRITICAL: Never reload, restart, quit, or launch Hammerspoon after editing its configuration. Do not use `hs.reload()`, AppleScript, `killall`, `open -a`, or Hammerspoon menu/UI actions for this purpose. After making Hammerspoon changes, ask Aubrey to reload or restart Hammerspoon manually.


## Session memory organization

- At the start of each session, create one unique private directory under `/tmp` for that session (for example, with `mktemp -d /tmp/codex-session.XXXXXX`). Keep that directory path available in the active task context.
- Keep the task-specific continuity log required above, but place each task's log inside the session directory. Use a new, clearly named file for every distinct task or subject rather than reusing one file.
- Keep a concise `index.md` in the session directory. List each task memory by exact filename with its topic and status, and mark the current active memory. Update the index when a task starts, finishes, or the session changes subjects.
- When work shifts to a new task or subject, create a new focused memory file and leave earlier files intact. Record only the decisions, findings, dependencies, and next steps needed to resume that task; link to an earlier memory when the new task depends on it.
- After compaction, read the session index and the exact active task memory first. Consult an earlier memory from this same session only when the index or active memory points to context needed for the current task. Do not search `/tmp` for memories or read unrelated session or agent memories.
