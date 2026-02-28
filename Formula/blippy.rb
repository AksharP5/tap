class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.6/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "8e21043437f075b85660e9fe54f033fa5abb4c9c82058ff0e93b09120759e66a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.6/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "351cd47ff612b36699921e884f6adff17a62eeec289c7881d6c794d1867da95d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.6/blippy-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7f54dd067a62302c6d939d3e07b8c30bd700897308a6def695f369b832a245e9"
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
