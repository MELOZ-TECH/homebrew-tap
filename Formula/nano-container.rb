class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.8.0/nanoc-v0.8.0-darwin-arm64.tar.gz"
  sha256 "6f193931dd017ccf5261087599fb2f1a456195b956fb088049f979dc0cf40269"
  version "0.8.0"
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

  test do
    assert_match "nanoc", shell_output("#{bin}/nanoc --version")
  end
end
