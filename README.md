# Homebrew tap for [Termic](https://termic.dev)

One-liner install:

```sh
brew install --cask simion/termic/termic
```

That auto-taps this repo and installs the cask in a single step.

## Updates

```sh
brew upgrade --cask
```

Or just let Termic update itself — the app ships with an in-app updater
that fetches new releases from `https://termic.dev/updates/latest.json`.

## What this repo is

A Homebrew cask definition. Just one Ruby file (`Casks/termic.rb`)
pointing at the latest `.dmg` on the [Termic
releases](https://github.com/simion/termic/releases) page. The
cask is auto-bumped by GitHub Actions in `simion/termic` on every
release; nobody edits this repo by hand.

The `.dmg` is signed with a Developer ID certificate and notarized by
Apple (since 0.22.0), so it installs and launches with no Gatekeeper
prompt and nothing to strip. macOS verifies the signature and the
stapled notarization ticket on every launch. Termic is open source
(AGPL-3.0); if you want to verify what you're installing, build from
source or audit the `.dmg` from the Releases page before installing.
