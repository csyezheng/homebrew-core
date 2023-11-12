class A2fa < Formula
  desc "Command-line tool for generating and validating one-time password"
  homepage "https://github.com/csyezheng/a2fa"
  url "https://github.com/csyezheng/a2fa/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "bd3a65a2c982c8b224aa2a3c11ff62864d61764a6a30daf86832ba6fdc7d3599"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args, "./cmd/"
  end

  test do
    assert_match "no accounts found!\n", shell_output("#{bin}/a2fa list")
  end
end
