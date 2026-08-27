class GhWatch < Formula
  desc "Wait for a GitHub issue or pull request to close"
  homepage "https://github.com/BetoFrega/github-watch"
  url "https://github.com/BetoFrega/github-watch/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "019fc55ab6d3e9ede1facb18fcde381f82fb0a99a6d9f8b89d0fc426669318cb"
  license "MIT"

  depends_on "gh"

  def install
    bin.install "gh-watch"
  end

  test do
    assert_match "usage: gh-watch OWNER/REPO NUMBER", shell_output("#{bin}/gh-watch 2>&1", 2)
  end
end
