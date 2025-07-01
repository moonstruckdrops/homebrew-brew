cask "radioamp" do
  version "0.0.1"
  sha256 "sha256:a790a915812293403c3d544837b7982286e5503436d7d428da23012e577bb0af"

  url "https://github.com/moonstruckdrops/radioamp/releases/download/v#{version}/RadioAMP-#{version}.dmg"
  name "RadioAMP"
  desc "Radio Streaming Application"
  homepage "https://github.com/moonstruckdrops/radioamp"

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64

  app "RadioAMP.app"

  binary "#{appdir}/RadioAMP.app/Contents/MacOS/RadioAMP", target: "radioamp"

  zap trash: [
    "~/Library/Application Support/RadioAMP",
    "~/Library/Preferences/dev.kurobara.radioamp.plist",
    "~/Library/Logs/RadioAMP",
    "~/Library/Caches/RadioAMP"
  ]
end