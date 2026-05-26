# iCloud Drive — Organization Guide (edshah)

This guide is for **edshah** on macOS account **`ed`**. It does **not** replace the shared repo guide.

**Canonical rules (categories, PDF naming, conda env):** use the project root guide:

- [`ORGANIZATION_GUIDE.md`](../../ORGANIZATION_GUIDE.md)

**Ed-specific paths, folders to leave alone, and scripts:** this file and the `users/edshah/` directory.

---

## Profile

| Setting | Value |
|---------|--------|
| macOS user / home | `ed` → `/Users/ed` |
| iCloud root | `$HOME/Library/Mobile Documents/com~apple~CloudDocs` |
| Project clone (example) | `~/Developer/my_organizer` |

---

## What never to touch (edshah iCloud root)

In addition to the rules in [`ORGANIZATION_GUIDE.md` §2](../../ORGANIZATION_GUIDE.md), do **not** move, rename, or delete these **existing directories** on ed’s iCloud root:

| Folder | Notes |
|--------|--------|
| `Desktop`, `Documents`, `Downloads` | Standard iCloud / system-linked areas |
| `Books` | Existing library folder |
| `Developer` | Dev-related material |
| `Takeout 2_organized` | Organized Google Takeout |
| `macbackup_organized` | Organized Mac backup |
| `tina_ehsan_shared` | Shared folder |
| `Arrow_cs_arava_debug.key` | Existing folder (Keynote package) |

Category folders created by the organizer (`Resumes`, `Tesla`, `Other`, etc.) are intentional; only move **files** from the root into them per the main guide §3–§4.

---

## Scripts (ed only — do not change repo root scripts)

Use copies under **`users/edshah/`** so the upstream `organize_icloud.sh` and `ORGANIZATION_GUIDE.md` stay unchanged.

| File | Purpose |
|------|---------|
| [`config.sh`](config.sh) | Sets `ICLOUD_ROOT` to ed’s iCloud path |
| [`organize_icloud.sh`](organize_icloud.sh) | Same category logic as root script; runs against ed’s iCloud |
| [`organize_developer.sh`](organize_developer.sh) | Groups loose dirs under `~/Developer` into Projects, Tools, Learning, etc. |
| [`organize_projects.sh`](organize_projects.sh) | Groups flat `~/Developer/Projects/*` into conduit, ai-agents, science, … |
| [`DEVELOPER_ORGANIZATION_GUIDE.md`](DEVELOPER_ORGANIZATION_GUIDE.md) | Layout and rules for the Developer folder |
| [`PROJECTS_ORGANIZATION_GUIDE.md`](PROJECTS_ORGANIZATION_GUIDE.md) | Layout under `Projects/` |
| [`my_organizer.code-workspace`](my_organizer.code-workspace) | Opens repo + ed’s iCloud root in Cursor/VS Code |

### Run folder organization

```bash
cd ~/Developer/my_organizer
./users/edshah/organize_icloud.sh
./users/edshah/organize_developer.sh    # or --dry-run first
./users/edshah/organize_projects.sh     # after Developer pass
```

### Run PDF identify/rename (shared script, ed’s iCloud path)

```bash
conda activate org
ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
python pdf_identify_rename.py --dry-run "$ICLOUD/Resumes"
python pdf_identify_rename.py "$ICLOUD"
```

One-time env (from repo root): `conda env create -f env.yml`

---

## Current layout notes (May 2026)

- Category folders (`Resumes`, `Employment-HR`, …) were created at the iCloud root; most were empty until loose files appear there.
- Loose file **`Untitled.key`** may remain in the root until you add a rule or move it manually (e.g. to `Other/`).

---

## LLM instructions

1. Read **[`ORGANIZATION_GUIDE.md`](../../ORGANIZATION_GUIDE.md)** for categories, PDF workflow (§8), and conda env **`org`**.
2. Read **this file** for ed’s paths and skip-list folders.
3. Run **`users/edshah/organize_icloud.sh`**, not the root `organize_icloud.sh` (that script targets another user’s path).
4. Do **not** edit root `ORGANIZATION_GUIDE.md`, `organize_icloud.sh`, or `my_organizer.code-workspace` when working for edshah—only add or edit files under `users/edshah/`.
