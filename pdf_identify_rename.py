#!/usr/bin/env python3
"""
PDF identify & rename: extract first 100 words to a tmp file, identify document type,
rename to {content}_{MMM_YY}.pdf (e.g. invoice_sep_25.pdf).

Usage:
  python pdf_identify_rename.py <path-to.pdf>
  python pdf_identify_rename.py <directory>   # process all PDFs in directory
  python pdf_identify_rename.py --dry-run <path>   # show proposed names only
"""

import argparse
import os
import re
import sys
from datetime import datetime
from pathlib import Path

try:
    from pypdf import PdfReader
except ImportError:
    try:
        from PyPDF2 import PdfReader
    except ImportError:
        sys.exit("Install pypdf: pip install pypdf")

# Tmp dir for 100-word previews (LLMs can read these to identify content)
TMP_PREVIEW_DIR = os.environ.get("PDF_PREVIEW_DIR", "/tmp/pdf_previews")
WORD_LIMIT = 100

# Keywords (lowercased) -> short slug for filename. Order matters: first match wins.
CONTENT_KEYWORDS = [
    (["invoice", "invoiced", "bill", "payment due"], "invoice"),
    (["resume", "curriculum vitae", "cv", "experience summary"], "resume"),
    (["w-2", "w2", "wage and tax"], "w2"),
    (["insurance", "policy", "coverage"], "insurance"),
    (["agreement", "separation agreement", "mutual separation", "settlement"], "agreement"),
    (["certificate of status", "secretary of state", "good standing"], "certificate"),
    (["prescription", "medication", "pharmacy"], "prescription"),
    (["receipt", "paid in full", "transaction"], "receipt"),
    (["employment offer", "job offer", "offer letter"], "offer"),
    (["architectural", "drawing", "floor plan", "construction", "addendum"], "drawing"),
    (["quote", "estimate", "proposal"], "quote"),
    (["presentation", "slide", "deck"], "presentation"),
    (["insurance declaration", "declaration page"], "insurance_decl"),
]


def extract_first_n_words(pdf_path: str, n: int = WORD_LIMIT) -> str:
    """Extract text from PDF until we have at least n words. Returns single string of words."""
    reader = PdfReader(pdf_path)
    words = []
    for page in reader.pages:
        text = page.extract_text() or ""
        words.extend(re.findall(r"\S+", text))
        if len(words) >= n:
            break
    return " ".join(words[:n])


def get_date_slug(file_path: str) -> str:
    """Return MMM_YY from file modification time (e.g. sep_25)."""
    mtime = os.path.getmtime(file_path)
    dt = datetime.fromtimestamp(mtime)
    return dt.strftime("%b_%y").lower()  # sep_25


def identify_content(first_100_words: str) -> str:
    """Return a short slug based on keyword match in the text."""
    text_lower = first_100_words.lower()
    for keywords, slug in CONTENT_KEYWORDS:
        if any(kw in text_lower for kw in keywords):
            return slug
    # Fallback: first few meaningful words (alphanumeric), max 4, joined by underscore
    words = re.findall(r"[a-zA-Z0-9]{2,}", first_100_words)[:4]
    return "_".join(words).lower() if words else "document"


def write_preview_to_tmp(preview_text: str, base_name: str) -> str:
    """Write first-100-words preview to a tmp file. Returns path to tmp file."""
    os.makedirs(TMP_PREVIEW_DIR, exist_ok=True)
    safe_name = re.sub(r"[^\w\-.]", "_", base_name)[:80]
    tmp_path = os.path.join(TMP_PREVIEW_DIR, f"{safe_name}_preview.txt")
    with open(tmp_path, "w", encoding="utf-8") as f:
        f.write(preview_text)
    return tmp_path


def propose_new_name(content_slug: str, date_slug: str) -> str:
    """Propose filename: content_MMM_YY.pdf"""
    return f"{content_slug}_{date_slug}.pdf"


def process_pdf(pdf_path: str, dry_run: bool = False) -> None:
    path = Path(pdf_path).resolve()
    if not path.is_file() or path.suffix.lower() != ".pdf":
        return
    try:
        first_100 = extract_first_n_words(str(path), WORD_LIMIT)
    except Exception as e:
        print(f"  Skip (extract failed): {path.name} — {e}", file=sys.stderr)
        return
    if not first_100.strip():
        print(f"  Skip (no text): {path.name}", file=sys.stderr)
        return

    tmp_file = write_preview_to_tmp(first_100, path.name)
    date_slug = get_date_slug(str(path))
    content_slug = identify_content(first_100)
    new_name = propose_new_name(content_slug, date_slug)
    new_path = path.parent / new_name

    print(f"  Preview: {tmp_file}")
    print(f"  Identified: {content_slug}  Date: {date_slug}  -> {new_name}")

    if dry_run:
        return
    if new_path == path:
        return
    if new_path.exists() and new_path != path:
        # Avoid overwrite: append _2, _3, etc.
        stem = new_path.stem
        for i in range(2, 100):
            candidate = path.parent / f"{stem}_{i}.pdf"
            if not candidate.exists():
                new_path = candidate
                new_name = new_path.name
                break
    os.rename(str(path), str(new_path))
    print(f"  Renamed: {path.name} -> {new_name}")


def main():
    ap = argparse.ArgumentParser(description="Extract 100 words from PDF, identify type, rename to content_MMM_YY.pdf")
    ap.add_argument("path", help="PDF file or directory containing PDFs")
    ap.add_argument("--dry-run", action="store_true", help="Only print proposed names; do not rename")
    args = ap.parse_args()
    path = Path(args.path).expanduser().resolve()
    if not path.exists():
        sys.exit(f"Path not found: {path}")

    if path.is_file():
        process_pdf(str(path), dry_run=args.dry_run)
        return
    for f in sorted(path.iterdir()):
        if f.suffix.lower() == ".pdf":
            process_pdf(str(f), dry_run=args.dry_run)


if __name__ == "__main__":
    main()
