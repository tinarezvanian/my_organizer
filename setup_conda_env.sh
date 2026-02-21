#!/bin/bash
# Create Miniconda env "org" with Python 3.13. Install deps after activating.
# Run from project root: ./setup_conda_env.sh
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v conda &>/dev/null; then
  echo "Conda not found. Install Miniconda: https://docs.conda.io/en/latest/miniconda.html"
  echo "Then run: conda env create -f env.yml"
  exit 1
fi

if conda env list | grep -q '^org '; then
  echo "Env 'org' already exists. To reinstall: conda activate org && pip install -r requirements.txt"
  exit 0
fi

conda env create -f env.yml
echo ""
echo "Next: conda activate org"
echo "Then: pip install -r requirements.txt   (if not already installed via env.yml)"
