cask "termic" do
  version "0.1.1"
  sha256 ""

  url "https://github.com/simion/termic/releases/download/v#{version}/Termic_#{version}_aarch64.dmg"
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

  # tinyproxy is required for per-workspace network allowlisting on
  # sandboxed workspaces. Without it sandboxed agents fall back to
  # full network deny.
  depends_on formula: "tinyproxy"

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
