# NAS migration — start over (edshah)

**Goal:** Empty `ehsanshahos/Drive`, all data under `edshah/Drive` in a clear layout.

**Current state (after reset to staging):**
- `ehsanshahos/Drive` — empty (only `@eaDir`)
- `edshah/Drive/older_files/` — all migrated folders back here for a clean pass
- `edshah/Drive/` — keep as-is: `macsync`, `dlms`, `winsinc`, `config/`

---

## Phase 0 — Audit (before any moves)

1. List `older_files/` and `du -sh` each top-level item (on NAS via SSH).
2. Confirm `ehsanshahos/Drive` has no user data.
3. Do **not** rsync from source (source is empty).

## Phase 1 — Agree layout

Proposed top-level under `edshah/Drive`:

| Folder | Contents |
|--------|----------|
| `archive/` | backups, dropbox archives, `older`, `test_my_drive` |
| `media/` | photos, movies, music, family pics, `temp_images` |
| `personal/` | taxes, loan, family folders, `Ehsan_files` |
| `work/` | work, DLS, jssc, revit |
| `shared/` | `ehsan_tina`, `ET_Shared` |
| `property/` | house 2543 (merged subfolders) |
| `documents/` | `pdfs/`, `misc/` |
| `config/` | vpn (already exists) |

## Phase 2 — Move (one category at a time)

Use `mv` on the NAS only. Log each move to `_migrate.log`.

## Phase 3 — Verify

- `older_files/` empty or removed
- `ehsanshahos/Drive` still empty
- Spot-check large folders (`Ehsan_files`, `photos`, `archive/Backup`)

---

## Commands

```bash
ssh edshah@192.168.0.93
ls -la /volume1/homes/edshah/Drive/older_files/
ls -la /volume1/homes/ehsanshahos/Drive/
```
