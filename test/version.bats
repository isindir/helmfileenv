#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMFILEENV_ROOT}/versions" ]
  run helmfileenv-version
  assert_success "system (set by ${HELMFILEENV_ROOT}/version)"
}

@test "set by HELMFILEENV_VERSION" {
  create_version "1.11.3"
  HELMFILEENV_VERSION=1.11.3 run helmfileenv-version
  assert_success "1.11.3 (set by HELMFILEENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.11.3"
  cat > ".helmfile-version" <<<"1.11.3"
  run helmfileenv-version
  assert_success "1.11.3 (set by ${PWD}/.helmfile-version)"
}

@test "set by global file" {
  create_version "1.11.3"
  cat > "${HELMFILEENV_ROOT}/version" <<<"1.11.3"
  run helmfileenv-version
  assert_success "1.11.3 (set by ${HELMFILEENV_ROOT}/version)"
}
