# iCloud Drive Root — Organization Guide

This guide defines how to organize the root of **iCloud Drive** (`~/Library/Mobile Documents/com~apple~CloudDocs`). It is intended for humans and for LLMs that help maintain or re-apply this structure.

---

## Where files live (important)

**All organized files (PDFs, documents, photos, etc.) belong in iCloud Drive, not in the my_organizer project.**

| Location | Purpose |
|----------|---------|
| **iCloud Drive** — `~/Library/Mobile Documents/com~apple~CloudDocs` | **Canonical location.** All category folders (Resumes, Tesla, Home-Property, etc.) and the actual files live here. Organize, rename, and edit files **in iCloud**. |
| **my_organizer** (e.g. `~/Developer/my_organizer`) | **Tools and docs only.** Scripts (`organize_icloud.sh`, `pdf_identify_rename.py`), guide (`ORGANIZATION_GUIDE.md`), env (`env.yml`, `requirements.txt`). Do **not** put PDFs or organized data here. |

When editing or organizing PDFs (and other files), always work in **iCloud Drive**. Run the scripts **against the iCloud path** (see §4 and §8). The my_organizer repo is for version-controlled scripts and documentation; the data stays in iCloud.

---

## 0. Python environment (Miniconda) — use for all Python scripts

All Python tooling for this project (e.g. `pdf_identify_rename.py`) should run inside a **Miniconda** environment named **`org`** with **Python 3.13**. Install dependencies only in this env.

### 0.1 Create and use the env

**One-time setup:**

```bash
cd /path/to/my_organizer

# Option A: from env file (recommended)
conda env create -f env.yml

# Option B: manual
conda create -n org python=3.13 -y
conda activate org
pip install -r requirements.txt
```

**Every time you run Python scripts for this project:**

```bash
conda activate org
python pdf_identify_rename.py <path>
# or: python3 pdf_identify_rename.py <path>
```

### 0.2 Project files for the env

| File | Purpose |
|------|---------|
| `env.yml` | Conda env spec: name `org`, Python 3.13, pip deps (pypdf). Use: `conda env create -f env.yml`. |
| `requirements.txt` | Pip dependencies (e.g. `pypdf>=4.0.0`). Install inside `org`: `pip install -r requirements.txt`. |
| `setup_conda_env.sh` | Optional helper: creates env `org` with Python 3.13 and installs `requirements.txt` (requires conda in PATH). |

### 0.3 LLM instructions

When running or documenting Python commands for this project:

1. Use the **`org`** conda env with **Python 3.13**.
2. If the env does not exist, create it with `conda env create -f env.yml` (from the project root), or `conda create -n org python=3.13 -y` then `conda activate org` and `pip install -r requirements.txt`.
3. Before running `pdf_identify_rename.py`, ensure the env is activated: `conda activate org`.
4. **Work in iCloud Drive only for data.** Organize, rename, and edit PDFs (and other files) in `~/Library/Mobile Documents/com~apple~CloudDocs`. Do **not** put organized files or category folders in the my_organizer project; my_organizer is for scripts and docs only.

---

## 1. Goal and scope

- **Goal:** Keep the iCloud Drive **root** clean by moving loose files into category folders. Only the root is organized; existing subfolders (e.g. Downloads, project dirs) are left as-is.
- **Scope:** Operate only on **files** in the root. Do not rename, merge, or delete existing **folders** or **symlinks** unless the user explicitly asks.

---

## 2. What never to touch

Do **not** move, rename, or delete:

| Item | Reason |
|------|--------|
| **Hidden files** | Anything starting with `.` (e.g. `.icloud-drive.do-not-delete`, `.DS_Store`) |
| **Symlinks** | `Desktop`, `Documents` (they point to local folders) |
| **Existing directories** | `Downloads`, `SafariViewService`, `Tina_backup_may_9`, `leetcode`, `plans_16th_ave_ehsan`, `swc`, `webpack`, and any other **folder** that already exists |

When in doubt, only move **files** (not directories) from the root into the category folders below.

---

## 3. Folder structure and category rules

Create these folders in the iCloud Drive root if they do not exist. Then assign each **file** in the root to exactly one category using the rules below.

| Folder | Purpose | What belongs here (patterns / examples) |
|--------|---------|----------------------------------------|
| **Resumes** | Resumes and CVs | Filenames containing “resume” or “Resume” or “RESUME”; sample resumes (e.g. `Sample_*_resume.pdf`) |
| **Employment-HR** | Job offers, HR docs, separation, closeout | Employment offers, HR timelines, “Mutual separation agreement”, “Inv Closeout”, “Experience with …” work docs, interview prep guides |
| **Tesla** | Tesla-related docs and invoices | `TeslaInvoice*.pdf`, `tesla_invoice*.pdf`, `*tesla*.pdf`, `FILE_*tesla.pdf`, `lendingtesla.pdf` |
| **Home-Property** | Property, construction, plans, lighting | Address/construction drawings, architectural plans, “FOREST” docs, addendums, lighting quotes, “Shopping Bag Loft”, “Aries Alder” style/design |
| **Business-Legal** | Business registration, insurance, legal | California Secretary of State / Certificate of Status, “Insurance”, other official/corporate docs |
| **Personal** | Tax, health, personal recordings | W2s, prescriptions, personal audio (e.g. “ERC RECORDING”) |
| **Learning-Books** | Learning material and books | ML/DS books, “Algorithmic Adventures”, “Intro_Deep_Learning”, “Statistical_Machine_Learning”, “Survival_Analysis”, “Master DSA”, coding/workbook PDFs, “English words/workbook” |
| **Presentations** | Slide decks and presentation PDFs | e.g. “Google Cloud CE Presentation” and similar |
| **Photos-Media** | Images and short media | `IMG_*` (any extension: .PNG, .png, .jpg, .JPG, .MOV), `Screenshot*`, named photo files (e.g. `Tina_photo.PNG`) |
| **Other** | Misc and scripts | Single/multi PDFs with generic names, one-off PDFs (e.g. dec10_Juan, plan_hector), shell scripts (e.g. `cleanup.sh`) |

**Rule of thumb:** If a file clearly fits one category above, put it there. If it’s clearly not any of those, put it in **Other**. Do not create new top-level categories unless the user asks.

---

## 4. Step-by-step instructions (for an LLM or script)

**Always use the iCloud Drive path** — not the my_organizer folder. Files and category folders live in iCloud only.

1. **Set the root path**  
   - `ROOT = "~/Library/Mobile Documents/com~apple~CloudDocs"`  
   - Resolve `~` to the user’s home directory when running commands.  
   - This is the **only** location where organized files and category folders should be created or modified.

2. **List only files in the root**  
   - Ignore: hidden files, symlinks, and **all directories** (including Downloads, leetcode, etc.).

3. **Create category folders**  
   - For each folder in the table in §3, run `mkdir -p "$ROOT/<FolderName>"` if it does not exist.  
   - Do not delete or rename existing folders.

4. **Assign and move each file**  
   - For each file in the root, decide its category from §3 (by filename pattern or meaning).  
   - **For PDFs:** Optionally run the PDF naming workflow first (§8): extract first 100 words to a tmp file, identify content, rename to `{content}_{MMM_YY}.pdf`, then move.  
   - Move the file: `mv "$ROOT/<filename>" "$ROOT/<FolderName>/"`  
   - Use proper quoting for filenames with spaces or special characters (e.g. `"Single .pdf"`).

5. **Report**  
   - List any files still in the root after the run and, if useful, list contents or counts of each category folder.

---

## 5. Implementation notes (script / automation)

- **Case sensitivity:** Match both lowercase and uppercase where it matters (e.g. `*[Rr]esume*`, `*[Rr]ESUME*` for Resumes; `IMG_*.PNG` and `IMG_*.png` for Photos-Media).
- **Spaces in filenames:** Always quote paths: `mv "Single .pdf" "Other/"`.
- **Globs:** Prefer iterating with `for f in <pattern>; do [ -f "$f" ] && mv "$f" "<Folder>/"; done` so that non-matching globs and missing files do not cause errors.
- **Idempotency:** Running the script multiple times should be safe: already-moved files are no longer in the root, so they won’t be moved again.

The reference script is **`organize_icloud.sh`** in this project. When adding rules for new file types, add them to the script and to this guide (§3 and §5) so future runs and other LLMs stay consistent.

---

## 6. Edge cases and limitations

- **iCloud “cloud-only” (placeholder) files:** Some files may exist only in the cloud. Commands like `mv` or `cp` can fail with “No such file or directory” for those. Do not treat this as a script bug. Suggest the user open the file in Finder (or double-click) to download it, then run the organizer again or move it manually into the right category.
- **New categories:** If the user wants a new category (e.g. “Tax”, “Medical”), add a new row in §3, add a corresponding `mkdir` and move rules in the script, and document the pattern in this guide.
- **User-specific filenames:** Some move rules are based on known filenames (e.g. “Tina_Rezvanian”, “415-941-1257 FOREST”). When adding similar rules, prefer **patterns** (e.g. `*resume*`, `*FOREST*`) over exact names so the guide stays useful for other users or after renames.

---

## 7. Quick reference: category by keyword/pattern

- **Resumes** — resume, Resume, RESUME, Sample_*resume  
- **Employment-HR** — offer, HR, separation, closeout, interview prep, “Experience with”  
- **Tesla** — Tesla, tesla_invoice, *tesla*.pdf, lendingtesla  
- **Home-Property** — address/street, drawings, architectural, FOREST, addendum, lighting, Loft, Aries Alder  
- **Business-Legal** — California SOS, Certificate of Status, Insurance  
- **Personal** — W2, prescription, ERC RECORDING  
- **Learning-Books** — Algorithmic, Deep_Learning, Machine_Learning, Survival_Analysis, DSA, workbook, English words  
- **Presentations** — Presentation, slides  
- **Photos-Media** — IMG_, Screenshot, *photo*  
- **Other** — everything else in the root that is a file

---

## 8. PDF naming: identify and rename with content and date (MMM_YY)

For **PDF files**, use this workflow so that files get consistent, meaningful names including **content** and **date** in the form `MMM_YY` (e.g. `sep_25`).

### 8.1 Workflow (for humans and LLMs)

1. **Extract first 100 words**  
   From the PDF’s first page(s), extract text until you have at least 100 words. No images or layout—plain text only.

2. **Write preview to a tmp file**  
   Save those 100 words to a temporary file so that:
   - The same or another LLM can read the preview to refine identification.
   - You have a repeatable way to “see” what the document is without opening the PDF.
   - Suggested location: `/tmp/pdf_previews/<original_basename>_preview.txt` (or set `PDF_PREVIEW_DIR`).

3. **Identify what the file is**  
   Using the 100-word preview (and optionally the current filename), decide a **short content label** (e.g. `invoice`, `resume`, `insurance`, `agreement`, `w2`, `certificate`, `quote`, `drawing`). Prefer a single word or two joined by underscore; lowercase.

4. **Get the date in MMM_YY**  
   Use the **file modification date** of the PDF (or PDF metadata if available). Format: **MMM_YY** (e.g. `sep_25`, `apr_24`, `jan_26`). Month is three letters, lowercase; year is two digits.

5. **Rename the file**  
   New filename: **`{content}_{MMM_YY}.pdf`**  
   Examples:
   - `invoice_sep_25.pdf`
   - `resume_apr_25.pdf`
   - `insurance_dec_24.pdf`
   - `agreement_may_24.pdf`  
   If that name already exists, append `_2`, `_3`, etc. (e.g. `invoice_sep_25_2.pdf`). Do not overwrite existing files.

### 8.2 Script reference

Run **`pdf_identify_rename.py`** against **iCloud Drive** (or a category folder inside it), not against the my_organizer project. Example: `python pdf_identify_rename.py "/Users/tinarezvanian/Library/Mobile Documents/com~apple~CloudDocs/Resumes"`.

The project includes **`pdf_identify_rename.py`** (Python 3), which:

- Extracts the first 100 words from each PDF (using `pypdf`).
- Writes the preview to a tmp file under `PDF_PREVIEW_DIR` (default `/tmp/pdf_previews/`).
- Identifies content from keyword rules (invoice, resume, insurance, agreement, certificate, w2, prescription, etc.).
- Gets `MMM_YY` from the file’s modification time.
- Renames the file to `{content}_{MMM_YY}.pdf`.

**Usage:** (use the **`org`** conda env with Python 3.13 — see §0.) **Target iCloud Drive**, not my_organizer:

```bash
conda activate org
pip install -r requirements.txt   # one-time, if not already installed
# Run against iCloud path (where the PDFs actually live):
ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
python pdf_identify_rename.py "$ICLOUD/Resumes"
python pdf_identify_rename.py "$ICLOUD"           # all PDFs in iCloud root
python pdf_identify_rename.py <path-to.pdf>       # single file in iCloud
python pdf_identify_rename.py --dry-run <path>   # print proposed names only
```

**When an LLM runs the script:** The script prints the path to the tmp preview file. The LLM can read that file to double-check or override the automatic content label, then rename manually if desired, or extend the script’s keyword list in `CONTENT_KEYWORDS`.

### 8.3 Content identification keywords (quick reference)

Use the first 100 words (and optionally filename) to pick a label. Suggested mappings:

| If the preview suggests… | Use label |
|--------------------------|-----------|
| invoice, bill, payment due | `invoice` |
| resume, CV, experience summary | `resume` |
| W-2, W2, wage and tax | `w2` |
| insurance, policy, coverage | `insurance` |
| agreement, separation, settlement | `agreement` |
| certificate of status, secretary of state | `certificate` |
| prescription, medication, pharmacy | `prescription` |
| receipt, paid in full | `receipt` |
| employment offer, job offer | `offer` |
| architectural, drawing, plan, addendum | `drawing` |
| quote, estimate, proposal | `quote` |
| presentation, slide, deck | `presentation` |
| none of the above | short slug from first few meaningful words, or `document` |

### 8.4 Order of operations with folder organization

You can either:

- **Option A:** Run PDF naming first (so files are `content_MMM_YY.pdf`), then run the folder-organization script (§4) so they move into the right category folders; or  
- **Option B:** Run folder organization first, then run PDF naming inside each category folder.

Both are valid. The guide does not require one order; choose what fits the user’s workflow.

---

*Last updated to match `organize_icloud.sh`, `pdf_identify_rename.py`, env `org` (Python 3.13), and the current iCloud Drive layout.*
