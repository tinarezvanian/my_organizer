# my_organizer

Personal organization repo (see **`ORGANIZATION_GUIDE.md`** for category rules). This README records **computer setup**: Synology (**Matador**), SMB mounts, SSH, shell shortcuts, and the **iCloud → NAS backup** workflow.

Remote: **`https://github.com/tinarezvanian/my_organizer`** (`main`). Pull before edits, push when done.

---

## Synology SMB (“Matador”)

- **NAS IP:** `192.168.0.93`
- **DSM user:** `tina`
- **Share used for home folders:** `homes`
- Mount URL: `smb://tina@192.168.0.93/homes`

### Mount from Terminal

```bash
osascript -e 'mount volume "smb://tina@192.168.0.93/homes"'
```

### Persist SMB password

Use **Finder → Go → Connect to Server… (⌘K)** once with the same URL, sign in, and enable **Remember this password in my keychain**. After that, **`osascript`** and login-item apps can mount without prompting.

### Optional nickname in Finder (`~/Matador`)

```bash
ln -sf /Volumes/homes "$HOME/Matador"
```

The volume itself still appears as **`homes`** under **`/Volumes`**; **`Matador`** is a convenient shortcut path.

### Login: auto-mount at sign-in

1. **Script Editor** → save as application, e.g. `Mount Matador.app`:

   ```applescript
   try
   	mount volume "smb://tina@192.168.0.93/homes"
   end try
   ```

2. **System Settings → General → Login Items** → add that app.

---

## SSH with RSA (`tina@192.168.0.93`)

SMB and SSH use **different** credentials/stack: SSH keys do **not** replace the DSM password used for **`smb://`**.

Configured on the Mac (not in this repo):

- **Private key:** `~/.ssh/id_rsa_synology`
- **`~/.ssh/config`** aliases (example):

  ```sshconfig
  Host synology matador 192.168.0.93
    HostName 192.168.0.93
    User tina
    IdentityFile ~/.ssh/id_rsa_synology
    IdentitiesOnly yes
  ```

- **Authorized keys on NAS:** `homes/tina/.ssh/authorized_keys` (via SMB path or DSM).

### Interactive shell shortcut

In **`~/.zshrc`:**

```bash
connect-matador() {
  ssh synology "$@"
}
```

Reload: **`source ~/.zshrc`**, then **`connect-matador`** or **`connect-matador "cmd"`**.

---

## iCloud archive → Synology Drive backup

Canonical NAS root used:

**`/Volumes/homes/tina/Drive/backup/Tina_backup_may_9/`**

(Equivalent via shortcut: **`~/Matador/tina/Drive/backup/Tina_backup_may_9`**.)

### Strategy

1. **Copy first** from iCloud with **`rsync`** (do **not** delete from iCloud until sizes match):

   ```bash
   ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Tina_backup_may_9"
   DEST="/Volumes/homes/tina/Drive/backup/Tina_backup_may_9"
   mkdir -p "$DEST"
   rsync -avh --progress --exclude '.DS_Store' \
     "$ICLOUD/Disco" \
     "$ICLOUD/documents_446" \
     "$ICLOUD/downloads_443" \
     "$ICLOUD/work_dir" \
     "$DEST/"
   ```

2. **Verify** `du`/spot checks vs iCloud **before** emptying Trash on iCloud.

3. **Reorganize IDs + merge workspaces** — on the NAS, after **`rsync` is finished** (no live copy into those folders):

   - Read **`BACKUP_INDEX.md`** in that backup folder for the naming map.
   - Run **`apply_reorg.sh`** in that same folder (`chmod +x` once). It folds **technical** folders under **`projects/`** (`dcds_git_repo`, `work_dir`) and renames **`documents_446`** / **`downloads_443`** into stable labels.

Personal docs and download archives stay **outside** `projects/` so they are not merged blindly with repos.

### Security

A **`credentials`** file (or similar) may exist under **`documents_446`**. Treat backup copies like secrets: tighten share permissions on the Synology and rotate credentials if exposure is possible.

---

## Cursor / VS Code multi-root workspace (optional)

**`my_organizer.code-workspace`** opens this repo together with **`Tina_backup_may_9`** on iCloud. Paths are relative to `Developer/my_organizer`; adjust machine-to-machine if folders move.

---

## Quick reference

| Goal | Command / path |
|------|----------------|
| Mount Synology homes | `osascript -e 'mount volume "smb://tina@192.168.0.93/homes"'` |
| SSH to NAS | `ssh synology` or `connect-matador` |
| NAS Tina backup folder | `/Volumes/homes/tina/Drive/backup/Tina_backup_may_9/` |
| Reorg script (NAS) | `apply_reorg.sh` next to `BACKUP_INDEX.md` |
