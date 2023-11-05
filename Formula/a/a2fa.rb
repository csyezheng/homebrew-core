class A2fa < Formula
  desc "Command-line tool for generating and validating one-time password"
  homepage "https://github.com/csyezheng/a2fa"
  url "https://github.com/csyezheng/a2fa/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "a250e0112856e0865ccc3fefaf646bf39dab866055aaf878773c55584cea2e1c"
  license "Apache-2.0"
  head "https://github.com/csyezheng/a2fa.git", branch: "main"

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args, "./cmd/"
  end

  test do
    assert_empty shell_output("#{bin}/a2fa list")
  end
end
