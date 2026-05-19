# Markdown Lab Style Guide

## 1. Title format
Use a single H1 at the top.

```md
# Practice Lab 0101: Managing Identities in Entra ID
```

Use:
- `Practice Lab <number>: <lab title>`

## 2. Opening section order
Use this order at the top of every lab:

1. Title
2. Terms of use or important tenant warning if needed
3. Summary
4. Prerequisites if needed
5. Global notes or warnings if needed

Recommended pattern:

```md
# Practice Lab XXXX: Lab Title

## Summary

::: secondary
Brief lab summary in 1–3 sentences.
:::

### Prerequisites

::: secondary
To following lab(s) must be completed before this lab:

- prerequisite 1
- prerequisite 2
:::

::: warning
**Note**: Add important global learner note here.
:::
```

## 3. Exercises and tasks
Structure content as:

- `## Exercise X: Name`
- `### Task X: Name`

Do not skip this hierarchy.

Example:

```md
## Exercise 1: Configuring Entra Join
### Task 1: Configure Entra join Device settings
```

## 4. Scenario block
Start each exercise with a scenario inside a `secondary` callout.

```md
::: secondary
**Scenario**

Describe what the learner needs to achieve and why.
:::
```

Keep it short, practical, and outcome-focused.

## 5. Step writing rules
Write steps as checkbox items using numbered lists.

```md
1. [ ] Open **Microsoft Edge**.
2. [ ] Go to !!https://entra.microsoft.com!!.
3. [ ] Select **Users** > **All users**.
```

Rules:
- One action per step where possible
- Use present-tense imperative verbs: Open, Select, Enter, Verify, Close
- Keep steps explicit and literal
- Reference exact UI labels in bold
- Use checkbox format for all learner actions

## 6. UI formatting conventions
Use bold for:
- buttons
- menu items
- tabs
- fields
- page names
- option labels

Examples:
- **Next**
- **Users**
- **Licenses and apps**
- **Device settings**

Use `>` only for simple note-style callouts when not using fenced callouts, but prefer fenced callouts for consistency.

## 7. Variables and placeholders
Preserve platform variables and injected values exactly as literals.

Examples:
- `!!$gd.com(spM365Tenant).username!!`
- `!!https://entra.microsoft.com!!`
- `!!Allan Deyoung!!`

Do not rewrite or normalise these tokens.

## 8. Code blocks
Use fenced code blocks with language labels.

```md
```powershell
Get-MgUser
```
```

Rules:
- Use only when the learner must run commands or paste code
- Put a short instruction sentence immediately before the code block
- Keep code blocks clean and ready to paste

## 9. Callout usage
Use consistent fenced callouts:

### `secondary`
For summary, scenario, prerequisites, explanatory context

```md
::: secondary
content
:::
```

### `warning`
For cautions, portal changes, MFA prompts, timing delays, common errors, alternate paths

```md
::: warning
**Note**: Important caution or variation.
:::
```

### `danger`
For legal, tenant, destructive, or high-risk notices

```md
::: danger
High-risk or terms-of-use content.
:::
```

### `success`
For end-of-exercise results

```md
::: success
**Results**: After completing this exercise, you will have...
:::
```

## 10. Results statement
End every exercise with a success block.

```md
::: success
**Results**: After completing this exercise, you will have successfully configured...
:::
```

Use:
- “After completing this exercise...”
- one sentence only
- describe achieved outcome, not process

## 11. Tables
Use tables only when they improve setup clarity, such as:
- users to create
- licences to assign
- role mappings
- required values

Keep tables simple.

## 12. Screenshots
Use screenshots sparingly and only where the UI is hard to locate.

```md
![Screenshot](image-url)
```

Rules:
- Place screenshot directly after the step that introduces the screen
- Do not overuse
- Do not rely on screenshots instead of clear written steps

## 13. Tone and wording
Use:
- direct
- instructional
- neutral
- concise
- task-focused language

Do not use:
- conversational filler
- long explanations inside steps
- marketing language
- unnecessary theory

Good:
- “Select **Save**.”
- “Verify that **AzureAdJoined : YES** is displayed.”

Avoid:
- “Now you are going to want to…”
- “At this point, what we’re basically doing is…”

## 14. Good lab authoring patterns
Always include:
- exact portal or app being used
- exact object names
- exact values to enter
- what to verify after major actions
- warnings where portal layout may differ
- closing/cleanup steps if relevant

## 15. Common style issues to avoid
Avoid:
- inconsistent numbering
- restarting numbering accidentally unless required by renderer
- spelling mistakes in UI instructions
- mixing Azure AD and Entra ID terminology without reason
- overly long paragraphs between steps
- multiple unrelated actions in one step
- headings inside tasks unless truly needed

## 16. Recommended template
```md
# Practice Lab XXXX: Lab Title

## Summary

::: secondary
Brief summary of the lab.
:::

### Prerequisites

::: secondary
To following lab(s) must be completed before this lab:

- prerequisite 1
:::

::: warning
**Note**: Global learner note if needed.
:::

## Exercise 1: Exercise Name

::: secondary
**Scenario**

Brief scenario description.
:::

### Task 1: Task Name

1. [ ] Perform first action.
2. [ ] Perform second action.
3. [ ] Verify expected outcome.

```powershell
Example-Command
```

::: warning
**Note**: Add caution or alternate path if needed.
:::

::: success
**Results**: After completing this exercise, you will have successfully ...
:::
```

## 17. Agent instruction summary
For future lab-generation agents, use these rules:

- Always produce labs in `Exercise > Task > Step` format
- Use checkbox-numbered steps throughout
- Use bold for UI labels and controls
- Use fenced callouts: `secondary`, `warning`, `danger`, `success`
- Include a scenario block at the start of each exercise
- Include a results block at the end of each exercise
- Use PowerShell fenced code blocks for commands
- Preserve platform placeholder tokens exactly
- Keep wording concise, literal, and learner-action focused
- Add verification steps after key actions
- Add warning notes where portal behaviour may vary
