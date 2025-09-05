#!/bin/bash
# ./build.sh binaries
set -e
function error { echo "* $@" >&2; exit 1; }
[ $# -lt 1 ] && error "build.sh <outputdir> {<builddir>}" || true
[ -f /etc/env.sh ] && source /etc/env.sh || error "missing /etc/env.sh"

outputdir="$(readlink -m "$1")"; shift
[ $# -eq 0 ] && builddir="$(readlink -m "build")" || { builddir="$(readlink -m "$1")"; shift; }

echo "
builddir:   $builddir
output:     $outputdir
write:      $outputdir/$TAG/uv
"

mkdir -p "$builddir" "$outputdir/$TAG"
export CARGO_HOME="$builddir/cargo-cache"
export RUSTUP_HOME=/tmp

cd "$builddir"
    [ ! -d uv ] && git clone https://github.com/astral-sh/uv.git
    cd uv
        git checkout 0.8.14
        cargo add thiserror --package uv
        cargo build --no-default-features --release
        cp target/release/{uv,uvx} $outputdir/$TAG
