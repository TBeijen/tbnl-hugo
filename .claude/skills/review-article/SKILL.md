---
name: review-article
description: >
  Review a Hugo blog article for readability, spelling, punctuation,
  and internal consistency. Use when asked to review or proofread a
  blog post.
---

## What this skill does

Review a single blog article for mechanical errors and internal consistency.
The goal is to help the author catch mistakes — NOT to rewrite their voice.

This is a personal technical blog. The writing is conversational, opinionated,
and sometimes unconventional on purpose. That is a feature, not a bug.

## Article selection

1. If the user provides a specific file path, use that file.
2. If the user describes an article by title or topic (e.g. "the article about
   the zen of devops"), search `content/post/` for a matching file. Ask the
   user to confirm before proceeding.
3. If no article is specified, find the most recently dated article in
   `content/post/` by looking at the date prefix in filenames
   (format: `YYYY-MM-DD-slug.md`). Ask the user to confirm that is the
   article they want reviewed.

## What to review

Review the **markdown body text only**:

- Skip YAML frontmatter (between `---` delimiters at the top)
- Skip fenced code blocks (between ``` delimiters)
- Skip inline code (between backticks)
- Skip URLs and link targets
- Skip Hugo shortcode parameters and syntax
- DO review text inside Hugo shortcode captions and alt text
- DO review link text (the `[visible text]` part of links)
- DO review footnote text

## Review categories

Produce findings grouped into these categories:

### 1. Spelling and punctuation

- Typos and misspellings
- Missing, misplaced, or incorrect punctuation
- Unclosed parentheses or brackets
- Inconsistent capitalization of proper nouns, brand names, and compound
  terms (e.g. "DevOps" vs. "Devops", "GitHub" vs. "Github"). Flag any
  deviation from the established or official capitalization used elsewhere
  in the article or by the project/brand itself.
- Do NOT flag technical terms, tool names, proper nouns, or acronyms as
  spelling errors (e.g. Kubernetes, kubectl, Terraform, Hugo, etc.)

### 2. Overly complex sentences

- Sentences that are very long or have too many subordinate clauses, making
  them hard to parse on first read
- Suggest how to break them up or simplify, but keep the original meaning
  and tone intact
- Do NOT flag long sentences that read well — length alone is not the problem,
  clarity is

### 3. US/UK English consistency

- The baseline is **US English** (e.g. organize, customize, color, serialize,
  behavior, analyze, center, defense, license as verb)
- Flag any UK spellings that deviate from the baseline
- When flagging, briefly explain the US/UK difference
  (reference: https://en.wikipedia.org/wiki/American_and_British_English_spelling_differences)
- Respect the exceptions listed below — these are intentional preferences

**Exceptions — prefer these spellings despite US baseline:**
- `grey` (not gray)

To add more exceptions, edit the list above.

### 4. Contraction consistency

- Determine the **dominant style** for the article: does it mostly use
  contractions (`don't`, `isn't`, `can't`, `it's`, `won't`) or expanded
  forms (`do not`, `is not`, `cannot`)?
- Flag instances that deviate from the dominant style
- Report which style is dominant and the ratio (e.g. "14 contractions vs.
  3 expanded forms — dominant style is contractions")
- Common pairs to check: don't/do not, isn't/is not, can't/cannot,
  won't/will not, it's/it is, shouldn't/should not, wouldn't/would not,
  couldn't/could not, doesn't/does not, haven't/have not, aren't/are not,
  wasn't/was not, weren't/were not, that's/that is, there's/there is,
  we're/we are, they're/they are, you're/you are, I'm/I am, let's/let us,
  here's/here is

### 5. Phrase repetition

- Flag transitional phrases or distinctive expressions that appear multiple
  times in close proximity (within a few paragraphs of each other)
- Examples: "on the other hand", "in other words", "having said that",
  "it's worth noting", "at the end of the day", "the thing is",
  "needless to say", "as mentioned", "as a matter of fact"
- Also flag any non-transitional phrase or word pattern that is noticeably
  repeated in a short span and feels unintentional
- Do NOT flag intentional repetition used for rhetorical effect

### 6. Abbreviation and acronym consistency

- When an abbreviation or acronym is used, check that it is introduced in
  full at least once earlier in the article (e.g. "Simple Email Service
  (SES)" on first mention, then "SES" thereafter)
- Flag abbreviations that are used without ever being introduced in full
- Flag the full form being used again after the abbreviation has already
  been introduced, unless it is a deliberate re-explanation
- Do NOT flag acronyms and abbreviations that are universally understood
  by a technical audience and need no introduction (e.g. API, URL, DNS,
  HTTP, HTML, CSS, JSON, YAML, AWS, CI/CD, PR, CLI, SDK, SQL, SSH, TLS,
  REST, gRPC, OOP)

## What NOT to do

- Do NOT alter the author's tone, voice, or personal style
- Do NOT flag unconventional phrasing that is clearly intentional or adds
  character to the writing
- Do NOT suggest rewrites that make the text sound generic, corporate, or
  AI-generated
- Do NOT add filler like "In this article, we will...", "Let's dive in",
  "without further ado", or similar engagement-farming phrases
- Do NOT restructure paragraphs or sections
- Do NOT add content or expand on ideas
- Do NOT flag sentence fragments if they are clearly used for stylistic effect
- Preserve the human, conversational quality of the writing at all times

## Consistency scope

All consistency checks (US/UK, contractions, phrase repetition, abbreviations)
apply to the **single article being reviewed**. Inconsistencies between different articles
are irrelevant and should not be flagged.

## Output format

### Summary report

Produce a report grouped by category. For each finding, include:

- **Location**: line number and a short quote of the surrounding text for
  context
- **Issue**: what the problem is
- **Suggested fix**: the proposed replacement text

If a category has no findings, say so briefly (e.g. "No issues found.").

At the top of the report, include a one-line overall impression
(e.g. "Clean article with a few minor spelling issues and one complex
sentence.").

### After the report

Ask the user how they want to proceed:

- **Apply all**: apply every proposed change at once
- **One by one**: step through each proposed change individually, where the
  user can approve, deny, or provide an alternative for each one. When
  presenting each change, show the **full sentence** containing the issue
  plus 1-2 surrounding sentences for context, so the author can judge the
  change in situ — not just an isolated fragment.
- **Skip**: take no action (just keep the report for reference)

When applying changes, show a brief confirmation of what was changed.

## Remember

The purpose of this skill is to catch mechanical errors and accidental
inconsistencies. The author's voice is the product. Do not sand it down.
