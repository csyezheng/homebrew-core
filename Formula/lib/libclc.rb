class Libclc < Formula
  desc "Implementation of the library requirements of the OpenCL C programming language"
  homepage "https://libclc.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/libclc-17.0.4.src.tar.xz"
  sha256 "22ca3f60b43e5e68c4fe2f8a86bde87d2a6bccb0c8f26c47606cfe44f4126430"
  license "Apache-2.0" => { with: "LLVM-exception" }

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, sonoma:         "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, ventura:        "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, monterey:       "79373d6d1ffe31dad5c1c9c09a2062cf7171838c1cb9f877f088e7eadd177e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd89a2622cc8b3ef77eb9376eb61cfe933554a74df5d03672e445534e0895b4c"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => [:build, :test]
  depends_on "spirv-llvm-translator" => :build

  def install
    llvm_spirv = Formula["spirv-llvm-translator"].opt_bin/"llvm-spirv"
    system "cmake", "-S", ".", "-B", "build",
                    "-DLLVM_SPIRV=#{llvm_spirv}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace share/"pkgconfig/libclc.pc", prefix, opt_prefix
  end

  test do
    clang_args = %W[
      -target nvptx--nvidiacl
      -c -emit-llvm
      -Xclang -mlink-bitcode-file
      -Xclang #{share}/clc/nvptx--nvidiacl.bc
    ]
    llvm_bin = Formula["llvm"].opt_bin

    (testpath/"add_sat.cl").write <<~EOS
      __kernel void foo(__global char *a, __global char *b, __global char *c) {
        *a = add_sat(*b, *c);
      }
    EOS

    system llvm_bin/"clang", *clang_args, "./add_sat.cl"
    assert_match "@llvm.sadd.sat.i8", shell_output("#{llvm_bin}/llvm-dis ./add_sat.bc -o -")
  end
end
