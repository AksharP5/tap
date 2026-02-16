class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.5/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "75bdf84e7729b7d86f88abdf972c8fc166f3338a0204e454d78d63163081e9e0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.5/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "721e3acf13a16bc66424491b7075a7eabd13a13f59c1454c4f32c9ea3650c1b6"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.5/blippy-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "34655c1650c8a569cc099051b3a096e4a912e2af4f0caa00e6215fffaeb8a94c"
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
