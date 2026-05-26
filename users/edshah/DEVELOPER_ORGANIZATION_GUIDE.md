# Developer folder — Organization Guide (edshah)

Organize **`~/Library/Mobile Documents/com~apple~CloudDocs/Developer`** (also reachable as **`~/Developer`** when symlinked).

**Run:** `./users/edshah/organize_developer.sh` from `my_organizer` (use `--dry-run` first).

---

## Target layout

| Top-level folder | Purpose |
|------------------|---------|
| **Projects/** | Git repos grouped by domain — see [`PROJECTS_ORGANIZATION_GUIDE.md`](PROJECTS_ORGANIZATION_GUIDE.md) |
| **Tools/** | Editor/IDE tool data (Cline, Phoenix Code, Qt, React, Raspberry Pi Emulator) |
| **Learning/** | Book / course material (`Algorithmic_Adventures`, `TAlgorithmic_Adventures`) |
| **Media/** | Non-repo media (`videos`) |
| **Personal/** | Resume and similar (`ehsan_resume`) |
| **Installers/** | Installers (unchanged) |
| **Fonts/** | Font files (unchanged) |
| **Scripts/** | Loose scripts and small utilities (unchanged) |
| **my_organizer/** | This repo — stays at Developer root for short paths and workspace files |

---

## What stays at Developer root

- Hidden files (`.DS_Store`, etc.)
- Category folders above (including empty **Projects/** children)
- **my_organizer**

---

## Moves (idempotent)

Loose directories at the Developer root are moved into the category in the table. Already in the right place → no-op.

**Removed:** empty `untitled folder`.

**Note:** `TAlgorithmic_Adventures` is a near-duplicate of `Algorithmic_Adventures`; both live under **Learning/** until you merge or delete one.

---

## LLM instructions

1. Read this file and [`ORGANIZATION_GUIDE.md`](../../ORGANIZATION_GUIDE.md) (iCloud *root* is separate).
2. Run `users/edshah/organize_developer.sh --dry-run`, then without `--dry-run`.
3. Do not edit root `organize_icloud.sh`; add Developer rules only under `users/edshah/`.
4. After moving repos, update bookmarks/CI paths if they hard-coded old locations.
