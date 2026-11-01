class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.12.0/nanoc-v0.12.0-darwin-arm64.tar.gz"
  sha256 "8593f47d7a38e1dd7e26af006121df21b9e10904ae34a3cff1291d45c967974b"
  version "0.12.0"
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
