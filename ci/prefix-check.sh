#!/usr/bin/env bash

# Context
# =======
#
# pkg-config file would be broken when CMAKE_INSTALL_LIBDIR is absolute.
#
# See: https://github.com/rnpgp/rnp/issues/1835

declare tmpdir=

prep() {
  : "${REPO_DIR:?Missing REPO_DIR}"
  tmpdir=$(mktemp -d)
  pushd "$tmpdir"
  export tmpdir
  mkdir -p prefix prefix-include prefix-lib
  # rsync -a --exclude .git "${REPO_DIR}" .
  git clone "${REPO_DIR}"
  # rsync -a "${REPO_DIR}" .
  pushd rnp
}

build() {
  mkdir build && pushd build
  cmake -DCMAKE_INSTALL_PREFIX="$tmpdir"/prefix -DCMAKE_INSTALL_INCLUDEDIR="$tmpdir"/prefix-include -DCMAKE_INSTALL_LIBDIR="$tmpdir"/prefix-lib ..
  # make && make install
}

run_test() {
  echo grep -r "/$tmpdir/prefix" "$tmpdir"
  ! grep -r "/$tmpdir/prefix" "$tmpdir"
}

main() {
  prep
  build
  run_test
}

main "$@"
