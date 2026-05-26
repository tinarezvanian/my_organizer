# Projects folder — Organization Guide (edshah)

Organize **`~/Developer/Projects`** after the top-level Developer pass (`organize_developer.sh`).

**Run:** `./users/edshah/organize_projects.sh` (use `--dry-run` first).

---

## Target layout

| Folder | Projects |
|--------|----------|
| **conduit/** | Psiphon Conduit app, managers, relay, emergency, Iran firewall variants |
| **ai-agents/** | LLMs demo, agent-invest, ACIP, GPT notebooks, OpenClaw, polymarket-bot, DarkForest |
| **science/** | Raman/biblatex, lidar notebook, RadarInformer, vet SBIR ML, bridge fraud notebooks |
| **web/** | commerce-reference, DesignersDream (`dd`), Notus (`vinetka`) |
| **media/** | nfl_stream, voiceover |
| **homelab/** | dlm_helper, tpb_syno_search, rfcb (Freedom Bridge RFC) |

Each category holds project directories **one level deep** (`Projects/conduit/conduit`, not nested further).

---

## Path changes

Old: `~/Developer/Projects/conduit`  
New: `~/Developer/Projects/conduit/conduit` (main app repo nested under the **conduit** category folder)

Update CI, conda envs, and workspace paths that assumed a flat `Projects/` list.

---

## Notes

- **`iran-conduit-firewall`** and **`iran-conduit-firewall-1.1.1`** both live under **conduit/** until you merge or drop one.
- **`bridge`** (notebooks) is under **science/**; **`rfcb`** (single RFC file) is under **homelab/**.
- Re-run is idempotent: already-nested projects are skipped.

---

## LLM instructions

1. Run `organize_projects.sh --dry-run`, then without `--dry-run`.
2. Edit rules only under `users/edshah/`.
3. Do not flatten category folders back to `Projects/` root without user request.
