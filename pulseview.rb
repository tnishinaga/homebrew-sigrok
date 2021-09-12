class Pulseview < Formula
    desc ""
    homepage ""
    url "https://sigrok.org/download/source/pulseview/pulseview-0.4.2.tar.gz"
    sha256 "f042f77a3e1b35bf30666330e36ec38fab8d248c3693c37b7e35d401c3bfabcb"
    head "git://sigrok.org/pulseview"
  
    depends_on "qt@5"
    depends_on "cmake" => :build
    depends_on "pkg-config" => :build
    depends_on "glib" => :build
    depends_on "libftdi" => :build
    depends_on "libusb" => :build
    depends_on "libzip" => :build
    depends_on "glibmm@2.66" => :build
    depends_on "libsigc++@2" => :build
    depends_on "libserialport" => :build
    depends_on "tnishinaga/sigrok/libsigrok" => :build
    depends_on "tnishinaga/sigrok/libsigrokdecode"
  
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
  