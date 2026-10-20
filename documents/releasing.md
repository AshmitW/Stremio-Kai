# Releasing

Releases are built by `.github/workflows/release.yml` on a GitHub Windows runner. Nothing gets built on your machine.

This repo only holds `portable_config`. The workflow takes upstream's full Kai build (named in `installer/base.env`), copies this repo's `portable_config` over it, and publishes:

| File | Contents |
|---|---|
| `StremioKai_v<ver>_Setup.exe` | Inno Setup installer for the full build. Installs per-user to `%LOCALAPPDATA%\Programs\Stremio-Kai`, no admin needed. |
| `Stremio-Kai_v<ver>.7z` | Full portable build. |
| `StremioKai_v<ver>_Update.exe` | Patch installer with only the `portable_config` files changed since the base build. Finds the existing install on its own. |
| `Stremio-Kai_v<ver>_Update.7z` | The same changed files as an archive, to extract over an existing install. |

GitHub adds the "Source code" zip and tarball itself.

The first run also creates a `base-v4.8.0` pre-release holding a copy of upstream's 7z. Later builds download that copy, so releases keep working if upstream removes old assets. Don't delete it.

## Cutting a release

1. Bump `CURRENT_VERSION` in `portable_config/webmods/UI/update-notification.js`, e.g. `4.8.0-ashmit.2`. The in-app update check compares this against the latest release tag, and the workflow refuses a tag that doesn't match it.
2. Optional: write release notes in `installer/notes/v<ver>.md`. Without that file the workflow lists the commit subjects since the previous `v*` tag.
3. Commit and push to `main`.
4. Tag and push the tag:
   ```
   git tag v4.8.0-ashmit.2
   git push origin v4.8.0-ashmit.2
   ```
5. Watch it under the repo's Actions tab. A run takes roughly 15 to 30 minutes, mostly compressing the 400 MB build twice.

## Dry run

Actions > Release > Run workflow builds everything from `main` and attaches the four files to the run as an artifact (kept 3 days) without publishing a release. Use it after changing the workflow or the installer script.

## Moving to a new upstream version

When upstream ships, say, v4.9.0:

1. Merge upstream's `main` into this repo.
2. In `installer/base.env`, set `BASE_TAG`, `BASE_ASSET` and `BASE_COMMIT` to the upstream tag, its full 7z asset name, and the upstream commit that release was built from.
3. Set `CURRENT_VERSION` to `4.9.0-ashmit.1` and release as above. The workflow mirrors the new base on its first run.

## Fixing a bad release

Delete the release and tag, fix, then tag again:

```
gh release delete v4.8.0-ashmit.1 --cleanup-tag --yes
git tag -d v4.8.0-ashmit.1
```
