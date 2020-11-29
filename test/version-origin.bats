#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
}

@test "reports global file even if it doesn't exist" {
  assert [ ! -e "${HELMFILEENV_ROOT}/version" ]
  run helmfileenv-version-origin
  assert_success "${HELMFILEENV_ROOT}/version"
}

@test "detects global file" {
  mkdir -p "$HELMFILEENV_ROOT"
  touch "${HELMFILEENV_ROOT}/version"
  run helmfileenv-version-origin
  assert_success "${HELMFILEENV_ROOT}/version"
}

@test "detects HELMFILEENV_VERSION" {
  HELMFILEENV_VERSION=1 run helmfileenv-version-origin
  assert_success "HELMFILEENV_VERSION environment variable"
}

@test "detects local file" {
  echo "system" > .helmfile-version
  run helmfileenv-version-origin
  assert_success "${PWD}/.helmfile-version"
}

@test "doesn't inherit HELMFILEENV_VERSION_ORIGIN from environment" {
  HELMFILEENV_VERSION_ORIGIN=ignored run helmfileenv-version-origin
  assert_success "${HELMFILEENV_ROOT}/version"
}
