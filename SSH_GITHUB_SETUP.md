# SSH setup for GitHub (push via SSH)

SSH keys for GitHub are set up on this machine. Use this to add the public key to GitHub and verify.

## 1. Add the public key to GitHub

1. Copy your **public key** (one line):
   ```bash
   cat ~/.ssh/id_ed25519_github.pub
   ```
2. On GitHub: **Settings → SSH and GPG keys** (or https://github.com/settings/keys).
3. Click **New SSH key**.
4. Title: e.g. `Mac my_organizer` (or your machine name).
5. Key type: **Authentication Key**.
6. Paste the full line from step 1 into **Key**.
7. Click **Add SSH key**.

## 2. Test the connection

```bash
ssh -T git@github.com
```

You should see something like: `Hi <username>! You've successfully authenticated...`

## 3. Use SSH for push (existing repo)

If the repo was cloned with HTTPS, switch the remote to SSH:

```bash
git remote -v
git remote set-url origin git@github.com:USERNAME/REPO.git
git remote -v
```

Then push as usual:

```bash
git push -u origin main
```

## 4. Files on this machine

| File | Purpose |
|------|---------|
| `~/.ssh/id_ed25519_github` | Private key (keep secret). |
| `~/.ssh/id_ed25519_github.pub` | Public key (add to GitHub). |
| `~/.ssh/config` | Uses this key for `git@github.com`. |

## 5. Optional: load key in new terminals

To avoid re-entering a passphrase (if you add one later), add to `~/.zshrc`:

```bash
# Start ssh-agent and load GitHub key (if not already loaded)
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519_github 2>/dev/null
fi
```

On macOS, the key can also be stored in the Keychain: add `UseKeychain yes` and `AddKeysToAgent yes` under the `Host github.com` block in `~/.ssh/config` if you use a passphrase.
