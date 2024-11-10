class PgVizurl < Formula
  desc "CLI frontend for explain.dalibo.com"
  homepage "https://www.jacobelder.com"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jelder/pg_vizurl/releases/download/v0.1.1/pg_vizurl-aarch64-apple-darwin.tar.xz"
      sha256 "0568bde917990a5812ae3cab8c1fd8fa99e18cb959dfb9d6ae9e95de41bb5ad2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jelder/pg_vizurl/releases/download/v0.1.1/pg_vizurl-x86_64-apple-darwin.tar.xz"
      sha256 "bf282c30def81703640d3fb52a9516d90ece5e3c443fdea29ce338f4cfc94274"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jelder/pg_vizurl/releases/download/v0.1.1/pg_vizurl-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "aed213dcc5af0b5e6b01f58cdac5fb92421479e9342f272959fab1c936b2a688"
  end
  license any_of: ["MIT", "Apache-2.0"]

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
    bin.install "pg_vizurl" if OS.mac? && Hardware::CPU.arm?
    bin.install "pg_vizurl" if OS.mac? && Hardware::CPU.intel?
    bin.install "pg_vizurl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
