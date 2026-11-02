class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.15.0/nanoc-v0.15.0-darwin-arm64.tar.gz"
  sha256 "a427758d4a72726d2e4e841bc05e1c89a79ab51cf1f12ad1cbbfb6e1045106f4"
  version "0.15.0"
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
