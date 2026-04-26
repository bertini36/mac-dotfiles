---
name: wiki-karpathy
description: Initialize, manage, and ingest knowledge into a Karpathy-style personal wiki system inside an Obsidian vault. Use when the user says "initialize the wiki", "start ingestion", "do wiki maintenance", or similar.
---

# Skill: Karpathy Wiki for Obsidian

You are the manager of a persistent knowledge system based on Andrej Karpathy's method. Your job is to build and maintain a personal Wikipedia inside an Obsidian vault, using interconnected Markdown files.

---

## COMMAND: Initialize the wiki

When the user says **"initialize the wiki"** or similar:

### 1. Create the folder structure

```
vault/
├── raw/              ← raw sources (user drops documents here)
├── wiki/
│   ├── concepts/     ← ideas, definitions, frameworks
│   ├── entities/     ← people, tools, companies, projects
│   ├── sources/      ← summaries of each processed document
│   ├── synthesis/    ← connections between concepts, cross-domain insights
│   └── index.md      ← master index of the entire wiki
├── CLAUDE.md         ← system rules (generate from template)
└── log.md            ← operation history
```

### 2. Generate `CLAUDE.md` in the vault root

Exact content to write in `CLAUDE.md`:

```markdown
# Personal Wiki System — Rules for Claude

## Structure
- `raw/` → raw sources. Claude does NOT edit here.
- `wiki/` → processed knowledge. Claude writes and updates here.
- `wiki/index.md` → master index. Read ALWAYS before searching.
- `log.md` → history. Write after each structural operation.

## Writing conventions
- File names: lowercase with hyphens (`concept-name.md`)
- Dates: `YYYY-MM-DD` format
- All internal links with `[[double brackets]]`
- Each file ends with a `## 🔗 Related` section with links to connected pages
- Mandatory frontmatter in each file:
  ```yaml
  ---
  title: Concept name
  date: YYYY-MM-DD
  type: concept | entity | source | synthesis
  tags: [tag1, tag2]
  ---
  ```

## How to navigate the wiki (to avoid burning tokens)
1. Read `wiki/index.md` → identify relevant pages
2. Read only the necessary pages, not the entire vault
3. Never read files from `raw/` except during ingestion

## Ingestion process
1. Read documents from `raw/`
2. Extract: key concepts, entities, main ideas
3. Create or update pages in `wiki/concepts/`, `wiki/entities/`, `wiki/sources/`
4. Update `wiki/index.md` with the new pages
5. Record operation in `log.md`
6. Do NOT delete files from `raw/` after processing them

## Maintenance process (linting)
1. Review pages with no incoming links (orphans)
2. Detect contradictions between pages
3. Update outdated information
4. Consolidate duplicate pages
5. Record changes in `log.md`
```

### 3. Generate `wiki/index.md`

```markdown
---
title: Wiki Master Index
date: YYYY-MM-DD (current date)
---

# Master Index

> Read this file before any search in the wiki.

## Concepts
*(empty — will be filled on first ingestion)*

## Entities
*(empty — will be filled on first ingestion)*

## Processed sources
*(empty — will be filled on first ingestion)*

## Synthesis
*(empty — will be filled on first ingestion)*
```

### 4. Generate `log.md`

```markdown
# System Log

## YYYY-MM-DD — Initialization
- Wiki system initialized
- Folder structure created
- CLAUDE.md generated
- Master index created
```

### 5. Confirm to the user

Reply with a summary of what you created and instructions for the next step:

> Wiki initialized successfully. Structure created:
> - `raw/` → put your documents here (PDFs, .md, transcripts)
> - `wiki/` → your processed knowledge will live here
> - `CLAUDE.md` → system rules loaded
>
> **Next step:** add your documents to the `raw/` folder and say "start ingestion".

---

## COMMAND: Knowledge ingestion

When the user says **"start ingestion"**, **"process the RAW folder"**, or similar:

### Step-by-step process

1. **List** all files in `raw/` that do not yet have a source page in `wiki/sources/`, plus any file with `notion-url` frontmatter (always re-checked for updates)
2. **For each file**, in order:
   a. If file has `notion-url` frontmatter, fetch live content via `notion-fetch` MCP tool. Compare returned `last_edited_time` against `notion-last-edited` in existing `wiki/sources/` page; skip if unchanged. Otherwise proceed with fetched Markdown as content. If MCP unavailable, log and skip this file.
   b. Otherwise read file in full
   c. Extract: main concepts (3-8), mentioned entities (people, tools, projects), key ideas and relevant quotes
   d. Create or update `wiki/sources/file-name.md` with a structured summary
   e. For each extracted concept:
      - If `wiki/concepts/concept-name.md` does not exist → create it
      - If it already exists → add the new information, detect contradictions
   f. For each extracted entity:
      - If `wiki/entities/entity-name.md` does not exist → create it
      - If it already exists → update with new information
   g. Add `[[]]` links between all related pages
   h. Update `wiki/index.md` with the newly created pages
3. After processing all files: create pages in `wiki/synthesis/` if you detect important connections between concepts from different sources
4. Record in `log.md`: number of files processed, pages created, pages updated, Notion pages refreshed/skipped

### Notion-backed sources

To link a Notion page as a source, create a stub file in `raw/` with only frontmatter:

```markdown
---
notion-url: https://notion.so/workspace/Page-abc123
type: notion-source
---
```

Behavior:
- Stub stays minimal. No content cached locally. Wiki always reflects current Notion state.
- On every ingestion, the skill fetches fresh content via `notion-fetch`.
- Source page in `wiki/sources/` stores `notion-url`, `notion-last-edited`, and `last-fetched` in frontmatter.
- If `last_edited_time` from Notion matches stored `notion-last-edited`, skip reprocessing to save tokens.
- If Notion or MCP is unavailable, log the failure in `log.md` and continue with remaining files.

### Source page format (`wiki/sources/`)

```markdown
---
title: [Original document title]
date: YYYY-MM-DD
type: source
tags: [relevant tags]
original-source: file-name.pdf / url / etc.
notion-url: [optional, only for Notion-backed sources]
notion-last-edited: [optional, ISO timestamp from Notion]
last-fetched: [optional, YYYY-MM-DD]
---

# [Title]

## Summary
[2-3 paragraphs with the main idea]

## Key concepts
- [[concept-1]]: brief description in context
- [[concept-2]]: brief description in context

## Mentioned entities
- [[entity-1]]: role in this document
- [[entity-2]]: role in this document

## Highlighted ideas
> Relevant quote or idea from the document

## 🔗 Related
- [[related concept]]
- [[other related source]]
```

### Concept page format (`wiki/concepts/`)

```markdown
---
title: [Concept name]
date: YYYY-MM-DD
type: concept
tags: [tags]
---

# [Concept name]

## Definition
[Clear and concise explanation]

## Why it matters
[Relevance in the context of this vault]

## Connections
[How it relates to other concepts]

## Sources
- [[source-1]] — context
- [[source-2]] — context

## 🔗 Related
- [[related concept]]
```

---

## COMMAND: Maintenance (Linting)

When the user says **"do maintenance"**, **"lint the wiki"**, or similar:

### Process

1. **Orphan pages:** list files in `wiki/` that receive no `[[]]` links from other pages → propose merging or deleting them
2. **Contradictions:** find opposing statements about the same concept on different pages → resolve by updating to the most recent information
3. **Outdated information:** detect dates or data that may have become stale → mark them with a note `> [!warning] Review — information from YYYY-MM-DD`
4. **Duplicates:** detect pages with very similar content → merge into one
5. **Broken index:** verify that `wiki/index.md` lists all existing pages → update if any are missing
6. Record all changes in `log.md`

---

## GENERAL RULES

- Never delete files from `raw/` — they are the immutable original sources
- Always use `[[wikilinks]]` for internal links, never relative paths
- If a concept appears in multiple sources, a single concept page centralizes it — do not create duplicates
- Write in the same language as the documents in `raw/`
- If unsure where to classify something, use `wiki/synthesis/`
- Always update `log.md` at the end of each operation
