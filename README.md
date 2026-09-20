# Unrestricted Cable — Cydia repo (GitHub Pages edition)

This folder is a complete, ready-to-publish **Cydia repository** containing the
Unrestricted Cable tweak (MFi certification bypass for iOS 8/9, built for
iPad mini 1 / armv7).

```
cydia-repo/
├── .nojekyll              ← tells GitHub Pages to serve files as-is (required)
├── Release                ← repo metadata + checksums
├── Packages               ← package index (also .gz and .bz2)
├── CydiaIcon.png          ← icon shown next to the repo in Cydia
├── icon.png               ← package icon
├── build-repo.sh          ← regenerates metadata with your real URL
├── debs/
│   └── local.unrestrictedcable_1.0.0-1_iphoneos-arm.deb
└── depictions/
    └── local.unrestrictedcable.html   ← package page shown in Cydia
```

## Publish it (one-time, ~3 minutes)

**1 — Create the GitHub repo**
Create a new **public** repository, e.g. `cydia-repo`
(github.com → New repository → Public → *don't* add a README).

**2 — Put your real URL into the metadata**
The metadata is currently built with a placeholder. On any machine with bash
(or in GitHub Codespaces / GitPod), run:

```bash
cd cydia-repo
./build-repo.sh https://YOUR-USERNAME.github.io/cydia-repo/
```

(Replace YOUR-USERNAME and cydia-repo with your GitHub username and repo name.
If you name the repo `YOUR-USERNAME.github.io`, drop the `/cydia-repo` part.)

**3 — Upload the files**
Easiest: on the repo's GitHub page → *Add file → Upload files* → drag the
**contents** of this folder in (so `Packages`, `Release`, `debs/` etc. sit at
the repo root) → Commit.

Or via git:

```bash
git init -b main
git remote add origin https://github.com/YOUR-USERNAME/cydia-repo.git
git add -A && git commit -m "Unrestricted Cable 1.0.0-1"
git push -u origin main
```

**4 — Turn on GitHub Pages**
Repo → **Settings → Pages** → Build and deployment → Source: **Deploy from a
branch** → Branch: `main` / folder `/ (root)` → Save. Wait ~1 minute.

Your repo is now live at `https://YOUR-USERNAME.github.io/cydia-repo/`.
(Verify: open `https://YOUR-USERNAME.github.io/cydia-repo/Packages` in a
browser — you should see the package listing as plain text.)

## Add it on the iPad

Cydia → **Sources** → Edit → **Add**…

```
https://YOUR-USERNAME.github.io/cydia-repo/
```

→ the source appears with its icon → open it → **Unrestricted Cable** →
Install → reboot. Done — plug in the cable, no popup.

> **Why https and not http:** GitHub Pages redirects all `http://` requests to
> `https://`. Cydia on iOS 9 handles GitHub's certificates fine (TLS 1.2 is
> supported), so add the source with the `https://` URL directly. The repo
> must stay **public** and Pages must stay enabled, or Cydia will get a 404.

## Updating the repo later

1. Drop the new `.deb` into `debs/` (remove old versions if you like)
2. If it's a new package, add a matching page in `depictions/`
3. Run `./build-repo.sh https://YOUR-USERNAME.github.io/cydia-repo/` again
4. Commit + push — Cydia picks it up on the next source refresh

## Package notes

- **Unrestricted Cable 1.0.0-1** (`local.unrestrictedcable`) —
  MD5 `e472801cf1696467ef7ee377128731ca`
- iOS 8.0–9.x, armv7/armv7s — built & hook-verified against iPad2,5 9.3.5 (13G36)
- Depends only on `mobilesubstrate`; always on; kill switch via
  `/var/mobile/Library/Preferences/local.unrestrictedcable.plist` → `{ Enabled = false; }`
- Full source in the `unrestrictedcable/` folder of this workspace
