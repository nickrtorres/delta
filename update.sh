#!/bin/sh
#
# Updates installed version of delta in /usr/local/bin

set -e

pull()
{
  git fetch --quiet --all
  git merge --quiet --ff-only
}

build()
{
  cargo clean --release --quiet
  cargo build --release --quiet
}

get_version_at_head()
{
  cargo run --release --quiet -- --version | sed 's/[[:space:]]+/./'
}

get_installed_version()
{
  /usr/local/bin/delta --version | sed 's/[[:space:]]+/./'
}

main()
{
  pull
  build

  if [ "$(get_version_at_head)" == "$(get_installed_version)" ]; then
    printf "delta version %s is already up to date.\n" "$(get_installed_version)"
    exit 0;
  fi


  next=$(get_version_at_head)
  cp ./target/release/delta /usr/local/bin/"$next"
  ln -sf /usr/local/bin/"$next" /usr/local/bin/delta
  printf "delta version is now %s.\n" "$(get_installed_version)"
}

main
