# NAS Drive migration (edshah)

**Status:** Reset 2026-05-18 — re-org in progress (see `NAS_MIGRATION_PLAN.md`)

**Previously completed:** 2026-05-18 (superseded by staging reset)

## Source → destination

| From | To |
|------|-----|
| `/volume1/homes/ehsanshahos/Drive/` | `/volume1/homes/edshah/Drive/` (organized layout) |

**Source status:** Only `@eaDir` remains under `ehsanshahos/Drive` (no user files/folders).

## Layout under `edshah/Drive`

| Folder | Contents |
|--------|----------|
| `archive/` | `Backup`, `_Dropbox (Old)`, `backup_from_mac`, `dropbox_dec_2020`, `older`, `test_my_drive` |
| `media/` | `photos`, `movies`, `music_project`, `Late Shahosseini Pics`, `temp_images` |
| `personal/` | `2020_taxes`, `loan`, `quintina`, `wilfredo`, `Ehsan_files` |
| `work/` | `work`, `DLS`, `jssc-EOPLL`, `revit` |
| `shared/` | `ehsan_tina`, `ET_Shared` |
| `property/house_2543_16th_ave/` | `from_drive`, `from_dropbox` (merged house folders) |
| `documents/pdfs/` | former `pdfs` folder |
| `documents/misc/` | loose PG&E PDF, Tina resume, Helli gsheet/json, `Untitled.pages` |
| `config/vpn/` | `.ovpn`, `protonvpn.zip`, `auth.txt` |
| *(unchanged)* | `macsync`, `dlms`, `winsinc` |

## Logs on NAS

- `_migrate_20260518_201750.log` — migration script log
- `_cleanup.log` — source dir removal (if present)

## Commands

```bash
# Mount
osascript -e 'mount volume "smb://edshah@192.168.0.93/homes"'

# Paths
~/Matador/edshah/Drive
```

## Notes

- Data was already copied to `older_files/` before migration; script moved into the layout above.
- `archive/_unfiled_from_older_files` was removed after migration (partial rsync staging; canonical copies live in `archive/`, `personal/`, `media/`).
