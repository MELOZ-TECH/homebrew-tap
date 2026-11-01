class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.6.0/nanoc-v0.6.0-darwin-arm64.tar.gz"
  sha256 "fa03a28b6994c4b48a8ee70fee20654002fc93aaf99333341d7378f124fe4a89"
  version "0.6.0"
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
