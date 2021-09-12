# Based on rob-deutsch's branch
# https://github.com/rob-deutsch/homebrew-core/tree/sigrok
class SigrokCli < Formula
  desc "Command-line frontend for sigrok"
  homepage "https://sigrok.org/wiki/Sigrok-cli"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.0.tar.gz"
  sha256 "5669d968c2de3dfc6adfda76e83789b6ba76368407c832438cef5e7099a65e1c"

  depends_on "glib" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "libsigrok"
  depends_on "libsigrokdecode"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sigrok-cli", "-L"
  end
end
