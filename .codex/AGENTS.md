- CRITICAL: You are forbidden from ever using git ever, so completely avoid using it.
- CRITICAL: Do not use Python for commands, scripts, one-off inspection, parsing, file edits, transformations, or automation.
- CRITICAL: Do not write or run non-Bash scripts to examine files or repository contents unless the user explicitly asks for that exact tool.
- Use Bash for shell work and prefer basic utilities such as `rg`, `sed`, `awk`, `find`, `ls`, `cat`, `head`, `tail`, and `wc`.

## Personal coding standards

Whenever a task may produce meaningful code, first inspect the applicable project instructions, documentation, enforced tooling, target language/runtime, and nearby source, then inspect `$aubreypwd-coding-standards` to determine whether Aubrey's standards are relevant. This applies to code written to files and code shown in examples, explanations, pseudocode, plans, diffs, patches, commands, configuration fragments, CLI output, IDE output, or other interfaces.

Before generating any code, ask the user explicitly whether to use `$aubreypwd-coding-standards` for the current task. Ask every time code will be generated unless the user has already answered that question for the current task. Do not generate the code until the user answers, and honor the user's choice.

If the user says yes, invoke the skill after inspecting the project and follow its complete workflow, including the compliance gate, before presenting the code as complete or standards-compliant. If the user says no, follow the applicable project-local standards and state that Aubrey's coding-standards skill was not applied. Explicit project-local standards take priority over the skill when both apply.
