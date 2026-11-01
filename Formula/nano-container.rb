class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.13.0/nanoc-v0.13.0-darwin-arm64.tar.gz"
  sha256 "5fbea4bd1180586a231d0ee943a4a6a338ae12d66b90f3cafec918abc84f9ff0"
  version "0.13.0"
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
