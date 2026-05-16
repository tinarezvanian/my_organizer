#!/bin/bash
# Organize iCloud Drive root for edshah (macOS: ed)
# Category rules match repo root organize_icloud.sh — see users/edshah/ORGANIZATION_GUIDE.md

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "$SCRIPT_DIR/config.sh"

ROOT="$ICLOUD_ROOT"
cd "$ROOT" || exit 1

# Folders to leave as-is on ed's iCloud root (documentation; moves only target files)
SKIP_REGEX='^\.|^Desktop$|^Documents$|^Downloads$|^Books$|^Developer$|^Takeout 2_organized$|^macbackup_organized$|^tina_ehsan_shared$|^Arrow_cs_arava_debug\.key$'

# Create category folders
mkdir -p "Resumes"
mkdir -p "Employment-HR"
mkdir -p "Tesla"
mkdir -p "Home-Property"
mkdir -p "Business-Legal"
mkdir -p "Personal"
mkdir -p "Learning-Books"
mkdir -p "Presentations"
mkdir -p "Photos-Media"
mkdir -p "Other"

# Resumes (match Resume, resume, RESUME)
for f in *[Rr]esume* *[Rr]ESUME* Sample_Supriya*.pdf; do
  [ -f "$f" ] && mv "$f" Resumes/ 2>/dev/null || true
done

# Employment / HR
mv "Adobe Employment Offer- Rezvanian, Tina_encrypted_ (1).pdf" Employment-HR/ 2>/dev/null || true
mv "HR_Timeline_summary_of_events.docx" Employment-HR/ 2>/dev/null || true
mv "Experience with NVIDIA.docx" Employment-HR/ 2>/dev/null || true
mv "Customer Engineering Specialist Interview Prep Guide [2022].pdf" Employment-HR/ 2>/dev/null || true
mv "Mutual separation agreement .pdf" Employment-HR/ 2>/dev/null || true
mv "Signed Mutual separation agreement.pdf" Employment-HR/ 2>/dev/null || true
mv "Inv Closeout_T Rezvanian.pdf" Employment-HR/ 2>/dev/null || true
mv "Inv Closeout_T.Rezvanian.pdf" Employment-HR/ 2>/dev/null || true

# Tesla
for f in TeslaInvoice*.pdf Tesla*.pdf; do
  [ -f "$f" ] && mv "$f" Tesla/ 2>/dev/null || true
done
mv tesla_invoice*.pdf Tesla/ 2>/dev/null || true
mv FILE_*tesla.pdf Tesla/ 2>/dev/null || true
mv lendingtesla.pdf Tesla/ 2>/dev/null || true

# Home / Property
mv "2543 16th Ave Drawings.pdf" Home-Property/ 2>/dev/null || true
mv "Architectural_plans_revision_1123.pdf" Home-Property/ 2>/dev/null || true
for f in "415-941-1257 FOREST"*.pdf; do
  [ -f "$f" ] && mv "$f" Home-Property/ 2>/dev/null || true
done
mv "Addendum 1.pdf" Home-Property/ 2>/dev/null || true
mv "Addendum 2.pdf" Home-Property/ 2>/dev/null || true
mv "Coastlighting quote.pdf" Home-Property/ 2>/dev/null || true
mv "light.pdf" Home-Property/ 2>/dev/null || true
mv "Shopping Bag  Loft.pdf" Home-Property/ 2>/dev/null || true
mv "Tina R- Aries Alder select.pdf" Home-Property/ 2>/dev/null || true

# Business / Legal
mv "California Certificate of Status (1).pdf" Business-Legal/ 2>/dev/null || true
for f in "California Secretary of State Records"*.pdf; do
  [ -f "$f" ] && mv "$f" Business-Legal/ 2>/dev/null || true
done
mv "Insurance .pdf" Business-Legal/ 2>/dev/null || true

# Personal
mv "Prescription-eye.pdf" Personal/ 2>/dev/null || true
mv "W2_2024_adobe_tina.png" Personal/ 2>/dev/null || true
mv "ERC RECORDING FEB 20.m4a" Personal/ 2>/dev/null || true

# Learning / Books
mv "Algorithmic Adventures Main (1).pdf" Learning-Books/ 2>/dev/null || true
mv "Intro_Deep_Learning"*.pdf Learning-Books/ 2>/dev/null || true
mv "Statistical_Machine_Learning"*.pdf Learning-Books/ 2>/dev/null || true
mv "Survival_Analysis"*.pdf Learning-Books/ 2>/dev/null || true
mv "Master DSA in 14 weeks"*.pdf Learning-Books/ 2>/dev/null || true
mv "Mybook (2) coding .pdf" Learning-Books/ 2>/dev/null || true
mv "English words.pdf" Learning-Books/ 2>/dev/null || true
mv "English workbook.pdf" Learning-Books/ 2>/dev/null || true

# Presentations
mv "2023 Google Cloud CE Presentation Prompt.pdf" Presentations/ 2>/dev/null || true

# Photos & Media
for f in IMG_*.PNG IMG_*.png IMG_*.jpg IMG_*.JPG IMG_*.MOV; do
  [ -f "$f" ] && mv "$f" Photos-Media/ 2>/dev/null || true
done
for f in Screenshot*; do
  [ -f "$f" ] && mv "$f" Photos-Media/ 2>/dev/null || true
done
mv "Tina_photo.PNG" Photos-Media/ 2>/dev/null || true

# Other (misc PDFs and scripts)
mv "Single .pdf" Other/ 2>/dev/null || true
mv "Multi.pdf" Other/ 2>/dev/null || true
mv "dec10_Juan.pdf" Other/ 2>/dev/null || true
mv "plan_hector.pdf" Other/ 2>/dev/null || true
mv "cleanup.sh" Other/ 2>/dev/null || true

echo "Done. Remaining files in root:"
ls -la
