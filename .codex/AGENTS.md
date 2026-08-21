- CRITICAL: You are forbidden from ever using git ever, so completely avoid using it UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO, you are NEVER allowed to push or pull.
- CRITICAL: Do not use Python for commands, scripts, one-off inspection, parsing, file edits, transformations, or automation UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO.
- CRITICAL: Do not write or run non-Bash scripts to examine files or repository contents unless the user explicitly asks for that exact tool UNLESS GIVEN EXPLICIT INSTRUCTIONS FROM THE USER TO DO SO.
- Use Bash for shell work and prefer basic utilities such as `rg`, `sed`, `awk`, `find`, `ls`, `cat`, `head`, `tail`, and `wc`.

## Personal coding standards

Whenever a task may produce meaningful code, first inspect the applicable project instructions, documentation, enforced tooling, target language/runtime, and nearby source, then inspect `$aubreypwd-coding-standards` to determine whether Aubrey's standards are relevant. This applies to code written to files and code shown in examples, explanations, pseudocode, plans, diffs, patches, commands, configuration fragments, CLI output, IDE output, or other interfaces.

Before generating any code, ask the user explicitly whether to use `$aubreypwd-coding-standards` for the current task. Ask every time code will be generated unless the user has already answered that question for the current task. Do not generate the code until the user answers, and honor the user's choice.

If the user says yes, invoke the skill after inspecting the project and follow its complete workflow, including the compliance gate, before presenting the code as complete or standards-compliant. If the user says no, follow the applicable project-local standards and state that Aubrey's coding-standards skill was not applied. Explicit project-local standards take priority over the skill when both apply.

## Plan mode

Treat Plan mode as a discussion-first planning process. Do not create, present, or update a formal plan, and do not ask plan-elicitation questions, merely because Plan mode has been entered or the user has supplied initial context.

In Plan mode, discuss the request naturally and wait until the user explicitly asks to create, draft, or present a plan. Once the user makes that request, create the plan and then ask only the additional questions needed to complete or validate it. Before that explicit request, answer conversationally, gather information offered by the user, and do not initiate a planning workflow.

## Installing Software

You are forbidden from installing software on your own, unless instructed to do so explicitly by the user. When you want to install software, you MUST ask the user to allow you to do it.