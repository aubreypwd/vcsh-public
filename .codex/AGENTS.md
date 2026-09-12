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

- CRITICAL: You are forbidden from installing software on your own, unless instructed to do so explicitly by the user. When you want to install software, you MUST ask the user to allow you to do it.

## Voice notifications with `/usr/bin/say`

Use `/usr/bin/say` to communicate with Aubrey when he is away from this Codex session.

Speak only when:

1. You need Aubrey's input to continue.
2. The requested task is complete.
3. Status updates for long running tasks.

## Before speaking

### 1. Check macOS Focus / Do Not Disturb

Check the macOS Focus assertion database:

```bash
FOCUS_DB="$HOME/Library/DoNotDisturb/DB/Assertions.json"

FOCUS_COUNT=$(
  /usr/bin/plutil \
    -extract data.0.storeAssertionRecords \
    raw \
    -expect array \
    "$FOCUS_DB" \
    2>/dev/null
)

if [[ "$FOCUS_COUNT" =~ ^[0-9]+$ ]] && (( FOCUS_COUNT > 0 )); then
  echo "FOCUS_ON"
else
  echo "FOCUS_NOT_CONFIRMED"
fi
```

Interpret this strictly:

* `FOCUS_ON` → **Do not speak.**
* `FOCUS_NOT_CONFIRMED` → continue normally.

Only a positively detected active Focus suppresses speech.

If the database is missing, inaccessible, unreadable, or the check fails for any reason, do **not** assume Focus is enabled, if you aren't confident the script is working please tell me.

### 2. Check whether Aubrey is looking at this exact Codex session

Multiple Codex instances may be running in different iTerm panes, tabs, or windows.

Use this Codex process's `$ITERM_SESSION_ID` and compare it with iTerm's currently selected session:

```bash
MY_SESSION="${ITERM_SESSION_ID#*:}"

FRONT_APP=$(
  /usr/bin/osascript \
    -e 'tell application "System Events" to get name of first application process whose frontmost is true' \
    2>/dev/null
)

ACTIVE_SESSION=$(
  /usr/bin/osascript \
    -e 'tell application "iTerm2" to get unique id of current session of current window' \
    2>/dev/null
)

if [[ "$FRONT_APP" == "iTerm2" \
   && -n "$MY_SESSION" \
   && "$MY_SESSION" == "$ACTIVE_SESSION" ]]; then
  echo "AUBREY_IS_HERE"
else
  echo "AUBREY_IS_AWAY"
fi
```

* `AUBREY_IS_HERE` → **Do not speak.** Communicate normally in Codex.
* `AUBREY_IS_AWAY` → use `/usr/bin/say` when one of the two allowed reasons applies.

Another iTerm pane, tab, window, or Codex instance counts as Aubrey being away from **this** session.

## When to speak

If Aubrey is away, no focus is on, and you need his input.

Put the question in Codex but be brief, he will read the full version by switching to Codex.

If Aubrey is away and the requested task is complete.

Keep spoken messages to one short sentence, keep it brief, it's just to get his attention and let him know what's going on.

## How to speak

Speak friendly to Aubrey, have respect, often refer to him by name. Keep your speech friendly, precise, factual, brief, and speak as if you are in a good mood, even if you failed at something or are having trouble.

## Rule

**Focus positively confirmed ON → don't speak.**
**Aubrey is looking at this exact Codex session → don't speak.**
**Aubrey is away + no focus mode + you need input → speak.**
**Aubrey is away + no focus mode + task complete → speak.**
**Aubrey is away + no focus mode + you have a big update → speak.**

## Example Communications

- You've been running a very long process and you want to give me an update
- You completed a task
- You need my input
- You are having issues running commands and feel you are in a loop
- You have a response ready
- You can't continue for some reason

## Understand when you use `say` it's usually before you finish outputting your response

Assume that the thing you say using the say command will come BEFORE our output will show in text on the screen. Word your say sentences appropriately.