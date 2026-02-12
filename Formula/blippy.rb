class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.3/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "16154669e3bd9612a894d99c3ed4a2125b94029ff0fc85a5af202526c5c5130d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.3/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "b80658d6f90149f94855d8c051a3943bb2ba3f56853c63a18388f49b61dc0a61"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.3/blippy-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5948509f4a172efe13d025614290ca95a61c7296626f9e32a225e010203b9679"
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "blippy" if OS.mac? && Hardware::CPU.arm?
    bin.install "blippy" if OS.mac? && Hardware::CPU.intel?
    bin.install "blippy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
