# Based on rob-deutsch's branch
# https://github.com/rob-deutsch/homebrew-core/tree/sigrok
class Libsigrok < Formula
  desc "Shared library of drivers for logic analyzers and input/output files"
  homepage "https://sigrok.org/wiki/Libsigrok"
  url "https://sigrok.org/download/source/libsigrok/libsigrok-0.5.2.tar.gz"
  sha256 "4d341f90b6220d3e8cb251dacf726c41165285612248f2c52d15df4590a1ce3c"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "doxygen" => :build
  depends_on "make" => :build
  depends_on "gettext" => [:buld, :test]
  depends_on "pkg-config" => [:buld, :test]
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libftdi"
  depends_on "libserialport"
  depends_on "libusb"
  depends_on "libzip"
  depends_on "tnishinaga/sigrok/sigrok-firmware-fx2lafw"

  patch :p1 do
    url 'https://gist.githubusercontent.com/tnishinaga/731e49de0907b5e497039f513f064f00/raw/51c07cdfb53f5f57e8829445f96e498406aaae26/support-glibmm-268.patch'
  end

  def install
    system "sed", "-i", "-e", "s/glibmm-2.4/glibmm-2.68/g", "configure"
    system "./configure", "--prefix=#{prefix}", "--disable-java", "--enable-bindings", "--enable-cxx", "CXXFLAGS=-std=c++17"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libsigrok/libsigrok.h>

      int main(int argc, char **argv)
      {
        int ret;
        struct sr_context *sr_ctx;
        if ((ret = sr_init(&sr_ctx)) != SR_OK) {
                printf("Error initializing libsigrok (%s): %s.",
                        sr_strerror_name(ret), sr_strerror(ret));
                return 1;
        }
        // Use libsigrok functions here...
        if ((ret = sr_exit(sr_ctx)) != SR_OK) {
                printf("Error shutting down libsigrok (%s): %s.",
                        sr_strerror_name(ret), sr_strerror(ret));
                return 1;
        }
        return 0;
      }
    EOS
    pkg_config_flags = `(pkg-config --cflags glib-2.0)`.chomp.split
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsigrok",
                   *pkg_config_flags, "-o", "test"
    system "./test"
  end
end
