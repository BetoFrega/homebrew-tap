class SshAgentPgp < Formula
  desc "OpenPGP signatures from an Ed25519 key in an SSH agent, as a drop-in gpg"
  homepage "https://github.com/BetoFrega/ssh-agent-pgp"
  url "https://github.com/BetoFrega/ssh-agent-pgp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "08a677a5de5828cfba5a96e3786396c69c7d63df7469231d80aeac3be6469e46"
  license "MIT"
  revision 1

  depends_on "go" => :build

  conflicts_with "gnupg", because: "both install a `gpg` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
    bin.install_symlink "ssh-agent-pgp" => "gpg"
  end

  def caveats
    <<~EOS
      This formula installs #{HOMEBREW_PREFIX}/bin/gpg, which signs with your SSH
      agent's key. Other gpg calls need GnuPG, which this replaces.

      Configure the key once:
        ssh-agent-pgp init --user-id "Your Name <you@example.com>" --agent-socket PATH
    EOS
  end

  test do
    assert_match "ssh-agent-pgp #{version}", shell_output("#{bin}/ssh-agent-pgp version")
    ENV["SSH_AGENT_PGP_HOME"] = testpath
    assert_match "ssh-agent-pgp #{version}", shell_output("#{bin}/gpg --version")
  end
end
