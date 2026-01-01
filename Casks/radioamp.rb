# GitHubのプライベートリポジトリの対応
# https://www.estie.jp/blog/entry/2024/08/06/100304
# https://dev.to/jhot/homebrew-and-private-github-repositories-1dfh
class GitHubPrivateRepositoryDownloadStrategy < CurlDownloadStrategy
  require "utils/formatter"
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    unless match = url.match(%r{https://github.com/([^/]+)/([^/]+)/(\S+)})
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Repository."
    end

    _, @owner, @repo, @filepath = *match
  end

  def download_url
    "https://#{@github_token}@github.com/#{@owner}/#{@repo}/#{@filepath}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    curl_download download_url, to: temporary_path
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    unless @github_token
      raise CurlDownloadStrategyError, "Environmental variable HOMEBREW_GITHUB_API_TOKEN is required."
    end

    validate_github_repository_access!
  end

  def validate_github_repository_access!
    # Test access to the repository
    GitHub.repository(@owner, @repo)
  rescue GitHub::HTTPNotFoundError
    # We only handle HTTPNotFoundError here,
    # becase AuthenticationFailedError is handled within util/github.
    message = <<~EOS
      HOMEBREW_GITHUB_API_TOKEN can not access the repository: #{@owner}/#{@repo}
      This token may not have permission to access the repository or the url of formula may be incorrect.
    EOS
    raise CurlDownloadStrategyError, message
  end
end

class GitHubPrivateRepositoryReleaseDownloadStrategy < GitHubPrivateRepositoryDownloadStrategy
  def initialize(url, name, version, **meta)
    super
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    "https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
  end

  private

  def _fetch(url:, resolved_url:, timeout:)
    # HTTP request header `Accept: application/octet-stream` is required.
    # Without this, the GitHub API will respond with metadata, not binary.
    curl_download download_url, "--header", "Accept: application/octet-stream", "--header", "Authorization: token #{@github_token}", to: temporary_path
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub::API.open_rest(release_url)
  end
end

cask "radioamp" do
  version "0.0.4"
  sha256 "4a57edbf6059597b594fcd98301d9d0a61f8f8dfa0913e5dfdf11904cc5cfd4c"
  # url "https://github.com/moonstruckdrops/radioamp/releases/download/v#{version}/RadioAMP-#{version}-arm64.dmg", using: GitHubPrivateRepositoryReleaseDownloadStrategy
  url "https://github.com/moonstruckdrops/radioamp/releases/download/v/RadioAMP-0.0.1-arm64.dmg", using: GitHubPrivateRepositoryReleaseDownloadStrategy

  name "RadioAMP"
  desc "Radio Streaming Application"
  homepage "https://github.com/moonstruckdrops/radioamp"

  depends_on macos: ">= :big_sur"
  depends_on arch: :arm64

  app "RadioAMP.app"

  binary "#{appdir}/RadioAMP.app/Contents/MacOS/RadioAMP", target: "radioamp"

  # インストールすると壊れている扱いになるので属性をクリアする対応
  # https://yotiosoft.com/support/help/macos-blocked.html
  # https://github.com/Homebrew/brew/issues/17979
  postflight do
    system "xattr -rc #{appdir}/RadioAMP.app"
  end

  zap trash: [
    "~/Library/Application Support/RadioAMP",
    "~/Library/Preferences/dev.kurobara.radioamp.plist",
    "~/Library/Logs/RadioAMP",
    "~/Library/Caches/RadioAMP"
  ]
end
