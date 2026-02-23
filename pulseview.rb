class Pulseview < Formula
    desc "Qt based LA/scope/MSO GUI"
    homepage "https://sigrok.org/"
    license "GPL-3.0-or-later"
    # The stable version cannot be built because it doesn't support >= CMake 3.5.
    head "git://sigrok.org/pulseview.git"
  
    depends_on "qt@5"
    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "glib" => :build
    depends_on "libftdi" => :build
    depends_on "libusb" => :build
    depends_on "libzip" => :build
    depends_on "glibmm@2.66" => :build
    depends_on "libsigc++@2" => :build
    # install following libraries with --HEAD before install pulseview
    depends_on "libsigrok"
    depends_on "libsigrokdecode"
    depends_on "libserialport"

  
    def install
        # Qt5 requires c++11 (and the other backends do not care)
        ENV.cxx11

        mkdir "build" do
            system "cmake", "..", *std_cmake_args
            system "make"
            system "make", "install"
        end
    end
  end
  