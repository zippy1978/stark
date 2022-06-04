#/bin/sh
RUSTFLAGS='-C link-args=-rdynamic' cargo build --verbose