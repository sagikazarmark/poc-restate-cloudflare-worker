{ pkgs, inputs, ... }:

{
  dotenv.enable = true;

  cachix.pull = [ "wrangler" ];

  packages = [
    pkgs.cargo-release
    pkgs.cargo-watch
    pkgs.lld
    # pkgs.worker-build
    inputs.wrangler.packages.${pkgs.stdenv.system}.wrangler
  ];

  languages.rust = {
    enable = true;
    # channel = "stable";
  };

  # Use unwrapped clang for wasm32 cross-compilation to avoid nix cc-wrapper
  # issues with multi-target compilation (ring crate requires this)
  env.CC_wasm32_unknown_unknown = "${pkgs.llvmPackages.clang-unwrapped}/bin/clang";
  env.AR_wasm32_unknown_unknown = "${pkgs.llvmPackages.llvm}/bin/llvm-ar";
}
