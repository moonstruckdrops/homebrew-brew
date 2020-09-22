class Kiex < Formula
  desc "Elixir version manager "
  homepage "https://github.com/taylor/kiex"
  head "https://github.com/taylor/kiex.git"

  depends_on "kerl"

  def install
    bin.install "kiex"
  end

  # MEMO:
  # インストール先がホームディレクトリのため
  # パーミッション不足でエラーとなる
  # 仕方ないので、インストールコメントでごまかす
  # def post_install
  #   system "#{bin}/kiex", "install_kiex"
  # end

  def caveats; <<~EOS
    Use our standalone setup:
      1) Run and follow the install steps:
        $ kiex install_kiex
      2) Erlang install steps:
        $ kerl list releases
        $ kerl build <Erlang version>
        $ kerl install <Erlang version>
      3) Then run
        $ kiex list known
        $ kiex install <Elixir version>
  EOS
  end

  test do
    system "false"
  end
end
