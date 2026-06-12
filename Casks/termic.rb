cask "termic" do
  version "0.11.4"

  # Universal macOS binary — single DMG that runs natively on Apple
  # Silicon AND Intel (arm64 + x86_64 fused via lipo at build time).
  # The `# @sha-arm` trailing anchor is load-bearing: release workflow
  # bump-tap job sed-targets this line. Name kept "sha-arm" for sed
  # back-compat; the binary itself is universal.
  sha256 "dee2719747dd2b2c2caa254e298c875b2eefcf0d6854674e339cd27f39490f11" # @sha-arm
  url "https://github.com/simion/termic/releases/download/v#{version}/Termic_#{version}_universal.dmg"

  name "Termic"
  desc "Free, open-source desktop app for running claude / gemini / codex in parallel git worktrees"
  homepage "https://termic.dev"

  # Bypass macOS Gatekeeper for unsigned builds. Termic is open source
  # (AGPL-3.0); if you want to verify, build from source. The in-app
  # updater (tauri-plugin-updater) verifies its own ed25519 signature on
  # every update package, so post-install updates ARE cryptographically
  # checked even though the initial .dmg isn't notarized by Apple.
  auto_updates true
  depends_on macos: ">= :monterey"

  app "Termic.app"

  # Disabling quarantine lets Termic open on first launch without the
  # "unidentified developer" Gatekeeper prompt. Acceptable because:
  #   1) This is our own tap (not homebrew/cask), so we set the policy.
  #   2) The .dmg is downloaded from a pinned GitHub Releases URL on
  #      simion/termic - same trust boundary as the source code.
  #   3) Future ed25519-signed updates are verified by the in-app
  #      updater regardless of macOS quarantine state.
  # MUST be `postflight` (not `installer script:`) - the `installer`
  # stanza runs BEFORE the `app` artifact is copied to /Applications,
  # so xattr fails with "no such file." `postflight` runs after every
  # artifact is in place.
  postflight do
    system_command "/usr/bin/xattr", args: ["-cr", "#{appdir}/Termic.app"]
  end

  zap trash: [
    "~/Library/Application Support/termic",
    "~/Library/Application Support/com.simion.termic",
    "~/Library/Caches/com.simion.termic",
    "~/Library/Preferences/com.simion.termic.plist",
    "~/Library/Saved Application State/com.simion.termic.savedState",
    "~/Library/WebKit/com.simion.termic",
  ]
end
