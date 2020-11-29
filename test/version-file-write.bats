#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run helmfileenv-version-file-write
  assert_failure "Usage: helmfileenv version-file-write <file> <version>"
  run helmfileenv-version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".helmfile-version" ]
  run helmfileenv-version-file-write ".helmfile-version" "1.11.3"
  assert_failure "helmfileenv: version \`1.11.3' is not installed"
  assert [ ! -e ".helmfile-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${HELMFILEENV_ROOT}/versions/1.10.8/bin"
  assert [ ! -e "my-version" ]
  run helmfileenv-version-file-write "${PWD}/my-version" "1.10.8"
  assert_success ""
  assert [ "$(cat my-version)" = "1.10.8" ]
}
