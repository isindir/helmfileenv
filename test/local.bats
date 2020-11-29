#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${HELMFILEENV_TEST_DIR}/myproject"
  cd "${HELMFILEENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.helmfile-version" ]
  run helmfileenv-local
  assert_failure "helmfileenv: no local version configured for this directory"
}

@test "local version" {
  echo "1.2.3" > .helmfile-version
  run helmfileenv-local
  assert_success "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .helmfile-version
  mkdir -p "subdir" && cd "subdir"
  run helmfileenv-local
  assert_success "1.2.3"
}

@test "ignores HELMFILEENV_DIR" {
  echo "1.2.3" > .helmfile-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.helmfile-version"
  HELMFILEENV_DIR="$HOME" run helmfileenv-local
  assert_success "1.2.3"
}

@test "sets local version" {
  mkdir -p "${HELMFILEENV_ROOT}/versions/1.2.3/bin"
  run helmfileenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helmfile-version)" = "1.2.3" ]
}

@test "changes local version" {
  echo "1.0-pre" > .helmfile-version
  mkdir -p "${HELMFILEENV_ROOT}/versions/1.2.3/bin"
  run helmfileenv-local
  assert_success "1.0-pre"
  run helmfileenv-local 1.2.3
  assert_success ""
  assert [ "$(cat .helmfile-version)" = "1.2.3" ]
}

@test "unsets local version" {
  touch .helmfile-version
  run helmfileenv-local --unset
  assert_success ""
  assert [ ! -e .helmfile-version ]
}
