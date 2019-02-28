Cross compile NixOS to Aarch64
---

# Building for Raspberry Pi 3

```bash
$ nix-build \
  -I nixpkgs=https://github.com/ElvishJerricco/nixpkgs/archive/cross-nixos-aarch64-2018-08-05.tar.gz \
  system.nix -A config.system.build.sdImage -o sdImage
$ sudo dd if=sdImage/sd-image/*.img of=/dev/YOUR_SD_CARD status=progress
```


TEMP


nix-build   -I nixpkgs=https://github.com/ElvishJerricco/nixpkgs/archive/cross-nixos-aarch64-2018-08-05.tar.gz   system.nix -A config.system.build.sdImage -o sdImage
dd if=/nix/store/cmh33sv8farj5p083ygqksw41jk0dq00-nixos-sd-image-18.09pre-git-x86_64-linux.img-aarch64-unknown-linux-gnu/sd-image/nixos-sd-image-18.09pre-git-x86_64-linux.img of=/dev/sdX bs=1MB
