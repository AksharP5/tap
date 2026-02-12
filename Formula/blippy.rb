class Blippy < Formula
  desc "Maintainer-first TUI for triaging GitHub issues and pull requests"
  homepage "https://github.com/AksharP5/blippy"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.1/blippy-aarch64-apple-darwin.tar.gz"
      sha256 "0df16946d8727ff809b68662fe31559ded2394d9c70b69b18dbded6f7eafa1e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.1/blippy-x86_64-apple-darwin.tar.gz"
      sha256 "6ff83f78ed724ddbdecceaebcd424a7d2083d794332164a01f87187441f69a2c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/AksharP5/blippy/releases/download/v0.1.1/blippy-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "6d432a06fb55b99c875f1e90c846c57fa9928d42d4e3717da049d931fc555067"
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
