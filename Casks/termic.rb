cask "termic" do
  version "0.27.2"
  # Universal macOS binary — single DMG that runs natively on Apple
  # Silicon AND Intel (arm64 + x86_64 fused via lipo at build time).
  # The `# @sha-arm` trailing anchor is load-bearing: release workflow
  # bump-tap job sed-targets this line. Name kept "sha-arm" for sed
  # back-compat; the binary itself is universal.
  sha256 "56a2f1568d2dfbb6a935272541fe0995210766e92ea323f91647ca18b57a6349" # @sha-arm

  url "https://github.com/simion/termic/releases/download/v#{version}/Termic_#{version}_universal.dmg",
      verified: "github.com/simion/termic/"
  name "Termic"
  desc "Run claude, gemini, and codex in parallel git worktrees"
  homepage "https://termic.dev/"

  # Required for Homebrew's autobump to track new releases. Kept here so this
  # cask stays byte-comparable with the one submitted to homebrew/cask.
  livecheck do
    url :url
    strategy :github_latest
  end

  # Signed with a Developer ID certificate and notarized by Apple as of
  # 0.22.0, so quarantine is left alone on purpose: Gatekeeper verifies the
  # signature and the stapled notarization ticket on first launch, and keeps
  # verifying on every launch after.
  #
  # There used to be a `postflight` here running `xattr -cr` on the installed
  # app. It existed because the .dmg was only ad-hoc signed, and it worked by
  # stripping the quarantine bit, which is what triggers the Gatekeeper check
  # in the first place. That bought a clean first launch at the cost of macOS
  # never validating the app at all. Do not add it back: it would silently
  # turn off the verification the notarization now pays for.
  auto_updates true
  depends_on macos: :monterey

  app "Termic.app"

  zap trash: [
    "~/Library/Application Support/com.simion.termic",
    "~/Library/Application Support/termic",
    "~/Library/Caches/com.simion.termic",
    "~/Library/Caches/termic",
    "~/Library/HTTPStorages/com.simion.termic",
    "~/Library/Preferences/com.simion.termic.plist",
    "~/Library/Saved Application State/com.simion.termic.savedState",
    "~/Library/WebKit/com.simion.termic",
  ]
end
