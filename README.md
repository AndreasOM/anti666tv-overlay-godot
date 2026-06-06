# anti666 - Overlay - Godot

A quick proof-of-concept reimplementation of my old HTML based stream overlay in Godot.

Work in progress!




### Cross compile for RaspberryPi

:WIP:

```
rustup target add armv7-unknown-linux-gnueabihf
```

```
rustup target add aarch64-unknown-linux-gnu
```

https://github.com/messense/homebrew-macos-cross-toolchains

```
brew tap messense/macos-cross-toolchains
```


```
brew install armv7-unknown-linux-gnueabihf
```

```
brew install aarch64-unknown-linux-gnu
```

~/.cargo/config.toml

```
[target.aarch64-unknown-linux-gnu]
linker = "aarch64-linux-gnu-gcc"

[target.armv7-unknown-linux-gnueabihf]
linker = "armv7-linux-gnueabihf-gcc"
```