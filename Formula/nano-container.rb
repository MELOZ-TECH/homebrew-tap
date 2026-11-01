class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.14.0/nanoc-v0.14.0-darwin-arm64.tar.gz"
  sha256 "2ee621c4bd5be274fe4890032ac0bc11582e9c380383d785d547e24088195580"
  version "0.14.0"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "nanoc"
    entitlements = buildpath/"build/virt.entitlements"
    # o binário precisa do entitlement de virtualização (assinatura ad-hoc)
    system "codesign", "--force", "--sign", "-", "--entitlements", entitlements, bin/"nanoc"
    pkgshare.install "build/virt.entitlements"
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      As correções do guest ficam nos assets da VM. Depois de instalar ou atualizar:
        nanoc down && nanoc bootstrap && nanoc up
    EOS
  end

  test do
    assert_match "nanoc", shell_output("#{bin}/nanoc --version")
  end
end
