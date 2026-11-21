class SshAgentPgp < Formula
  desc "OpenPGP signatures from an Ed25519 key in an SSH agent, as a drop-in gpg"
  homepage "https://github.com/BetoFrega/ssh-agent-pgp"
  url "https://github.com/BetoFrega/ssh-agent-pgp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "08a677a5de5828cfba5a96e3786396c69c7d63df7469231d80aeac3be6469e46"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def caveats
    <<~EOS
      Configure the key once:
        ssh-agent-pgp init --user-id "Your Name <you@example.com>" --agent-socket PATH

      For an app that looks for gpg in #{HOMEBREW_PREFIX}/bin, link it there
      and send the other gpg calls to GnuPG's own binary:
        ln -sf #{opt_bin}/ssh-agent-pgp #{HOMEBREW_PREFIX}/bin/gpg
        and set "gpg_program": "#{HOMEBREW_PREFIX}/opt/gnupg/bin/gpg" in
        ~/.config/ssh-agent-pgp/config.json
    EOS
  end

  test do
    assert_match "ssh-agent-pgp #{version}", shell_output("#{bin}/ssh-agent-pgp version")
    ln_s bin/"ssh-agent-pgp", testpath/"gpg"
    ENV["SSH_AGENT_PGP_HOME"] = testpath
    assert_match "gpg (GnuPG)", shell_output("#{testpath}/gpg --version")
  end
end
