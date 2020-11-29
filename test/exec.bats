#!/usr/bin/env bats

load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${HELMFILEENV_ROOT}/versions/${HELMFILEENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export HELMFILEENV_VERSION="0.0.0"
  run helmfileenv-exec version
  assert_failure "helmfileenv: version \`0.0.0' is not installed"
}

@test "fails with invalid version set from file" {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
  echo 0.0.1 > .helmfile-version
  run helmfileenv-exec rspec
  assert_failure "helmfileenv: version \`0.0.1' is not installed (set by $PWD/.helmfile-version)"
}
