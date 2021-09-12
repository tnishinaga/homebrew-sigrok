# Based on rob-deutsch's branch
# https://github.com/rob-deutsch/homebrew-core/tree/sigrok
class Libsigrokdecode < Formula
  desc "Shared library providing protocol decoding functionality"
  homepage "https://sigrok.org/wiki/Libsigrokdecode"
  # url "https://sigrok.org/download/source/libsigrokdecode/libsigrokdecode-0.5.3.tar.gz"
  url "git://sigrok.org/libsigrokdecode"
  version "HEAD"
  # sha256 "c50814aa6743cd8c4e88c84a0cdd8889d883c3be122289be90c63d7d67883fc0"

  # glib-2.0 >= 2.32.0
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => [:build, :test]
  depends_on "make" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "python@3.9"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    system "make", "install-decoders"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsigrokdecode/libsigrokdecode.h>
      #include <glib.h>

      int main(int argc, char **argv)
      {
        int ret;
        if ((ret = srd_init(NULL)) != SRD_OK) {
          printf("Error initializing libsigrokdecode (%s): %s.",
                  srd_strerror_name(ret), srd_strerror(ret));
          return 1;
        }
        srd_decoder_load_all();
        const GSList* decoders = srd_decoder_list();
        if (!decoders) {
          printf("Error listing decoders");
          return 1;
        };
        guint num_decoders = g_slist_length((GSList *)decoders);
        if (num_decoders == 0) {
          printf("No decoders listed");
          return 1;
        };
        return 0;
      }
    EOS
    pkg_config_flags = `pkg-config --cflags --libs glib-2.0`.chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsigrokdecode",
                   *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
