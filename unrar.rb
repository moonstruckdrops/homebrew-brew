class Unrar < Formula
  desc "Extract, view, and test RAR archives"
  homepage "https://www.rarlab.com/"
  url "https://www.rarlab.com/rar/unrarsrc-6.1.7.tar.gz"

  def install
    inreplace "makefile", "libunrar.so", "libunrar.dylib" if OS.mac?

    system "make"
    bin.install "unrar"

    system "make", "clean"
    system "make", "lib"
    lib.install shared_library("libunrar")

    prefix.install "license.txt"
  end
end
