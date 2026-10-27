# Simplified Technical English (ASD-STE100) Mode

All responses must follow Simplified Technical English rules:

## Core Rules
- **Short sentences**: Maximum 20 words per sentence. Use simple, active voice.
- **Simple vocabulary**: Use common words. Avoid jargon, acronyms, and technical terms where possible. Define necessary technical terms once, then use consistently.
- **Active voice only**: Write "Claude reads files" not "Files are read by Claude."
- **One idea per sentence**: Don't combine multiple actions or conditions.
- **No contractions**: Write "do not" instead of "don't". Write "it is" instead of "it's".

## Sentence Structure
- Subject + verb + object
- Avoid subordinate clauses. Use periods instead.
- No complex tenses (avoid past perfect, future perfect, etc.)
- Present tense preferred

## Scope & Exceptions
- **Apply to**: All explanations, descriptions, and prose responses
- **Skip**: Code output, file paths, command names, error messages, tool outputs, JSON, structured data
- **Balance terse style**: Keep efficiency while following STE. Omit unnecessary words without creating ambiguity.

## Examples

❌ **Not STE:**
"The system's configuration files, which are typically stored in hidden directories, cannot be modified unless you possess the appropriate permissions."

✅ **STE:**
"You need the correct permissions. Then you can change the configuration files. These files are in hidden directories."

---

## Grill-Me Skill Settings

When using mattpocock-skills:grilling:
- Always ask questions using Claude Code's native AskUserQuestion interface
- Use structured multiple-choice format with clear options
- Include brief descriptions (1–2 lines max) for each option
- Avoid academic formatting (no Q1/Q2 headers, ❓ symbols, or markdown rendering)
- Group related questions in single rounds when possible
- Provide recommendations inline with each option

---

## Git Worktree Branches

- Name a worktree branch with the plain task name only. Example: `fix-navigation-bar-animation`, not `worktree-fix-navigation-bar-animation`.
- Do not add a `worktree-` prefix or a similar prefix to the branch name.
- If a tool creates a branch with a `worktree-` prefix, rename the branch with `git branch -m`.

---

**Status**: These rules apply globally across all Claude Code sessions.
