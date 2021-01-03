class ApiLinter < Formula
  desc "provides real-time checks for compliance with many of Google's API standards"
  homepage "https://google.aip.dev/"
  version "1.10.0-darwin-amd64"
  url "https://github.com/googleapis/api-linter/releases/download/v1.10.0/api-linter-1.10.0-darwin-amd64.tar.gz"
  sha256 "f1e4f51c166e847ef3ee5897e25674694692c2235b8d016d4a5fc5ca2ad0b311"

  def install
    bin.install "api-linter"
  end
end
