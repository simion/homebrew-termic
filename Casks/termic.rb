cask "termic" do
  version "0.1.1"
  sha256 "5306e19234f5a9483b94f78c48b6ce77dca3b551aa94ddf1b33de64a18b6360b"

  url "https://github.com/simion/termic/releases/download/v#{version}/termic_#{version}_aarch64.dmg"
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

  app "termic.app"

  # Disabling quarantine lets Termic open on first launch without the
  # "unidentified developer" Gatekeeper prompt. Acceptable because:
  #   1) This is our own tap (not homebrew/cask), so we set the policy.
  #   2) The .dmg is downloaded from a pinned GitHub Releases URL on
  #      simion/termic - same trust boundary as the source code.
  #   3) Future ed25519-signed updates are verified by the in-app
  #      updater regardless of macOS quarantine state.
  installer script: {
    executable: "/usr/bin/xattr",
    args:       ["-cr", "#{appdir}/termic.app"],
    sudo:       false,
  }

  zap trash: [
    "~/Library/Application Support/termic",
    "~/Library/Application Support/com.simion.termic",
    "~/Library/Caches/com.simion.termic",
    "~/Library/Preferences/com.simion.termic.plist",
    "~/Library/Saved Application State/com.simion.termic.savedState",
    "~/Library/WebKit/com.simion.termic",
  ]
end
