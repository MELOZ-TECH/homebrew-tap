class NanoContainer < Formula
  desc "CLI-only container runtime for macOS on Virtualization.framework and libkrun"
  homepage "https://github.com/MELOZ-TECH/nano-container"
  url "https://github.com/MELOZ-TECH/nano-container/releases/download/v0.18.0/nanoc-v0.18.0-darwin-arm64.tar.gz"
  sha256 "2b0c5896be0ce4a32879bc447f62eb2c581fc244cf5b4100e9c1f7afbcc863d7"
  version "0.18.0"
  license "Apache-2.0"

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "nanoc"
    pkgshare.install "build/virt.entitlements"
    entitlements = pkgshare/"virt.entitlements"
    # pacotes com o backend libkrun trazem lib/libkrun.2.dylib, que o nanoc acha por
    # rpath em ../lib, e os entitlements dos dois backends
    if (buildpath/"lib/libkrun.2.dylib").exist?
      lib.install "lib/libkrun.2.dylib"
      pkgshare.install "build/krun.entitlements"
      entitlements = pkgshare/"krun.entitlements"
      # licença do libkrun (Apache-2.0), distribuído com o pacote
      doc.install "licenses/libkrun-LICENSE"
    end
    # o binário precisa dos entitlements (assinatura ad-hoc)
    system "codesign", "--force", "--sign", "-", "--entitlements", entitlements, bin/"nanoc"
    doc.install "README.md"
    doc.install "THIRD_PARTY.md" if File.exist?("THIRD_PARTY.md")
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
