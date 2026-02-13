class Blippy < Formula
  desc "GitHub in your terminal"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.4/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "39fbeef967de0d491c39189a2a32e1a06d8d1a0f88401e210e51b34146c4cf1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.4/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "162f14388a7fc6b0dd8f75ca56808fb2a9a1ff00bcd3501a471c088b633182f0"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.4/blippy-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c4c42c39a5c9bc44db40cd3717f014e3aa428e887176224b8b837e938c948206"
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
