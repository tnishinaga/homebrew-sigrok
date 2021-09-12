# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class SigrokUtil < Formula
  desc ""
  homepage ""
  url "git://sigrok.org/sigrok-util"
  version ""
  sha256 ""
  license ""

  depends_on "glibmm" => :build
  
  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    # https://rubydoc.brew.sh/Formula.html#std_configure_args-instance_method

    # /opt/homebrew/opt/openjdk/bin
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
    # system "cmake", "-S", ".", "-B", "build", *std_cmake_args
  end

end
