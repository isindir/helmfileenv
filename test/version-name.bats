#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
}

@test "no version selected" {
  assert [ ! -d "${HELMFILEENV_ROOT}/versions" ]
  run helmfileenv-version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  HELMFILEENV_VERSION=system run helmfileenv-version-name
  assert_success "system"
}

@test "HELMFILEENV_VERSION has precedence over local" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > ".helmfile-version" <<<"1.10.8"
  run helmfileenv-version-name
  assert_success "1.10.8"

  HELMFILEENV_VERSION=1.11.3 run helmfileenv-version-name
  assert_success "1.11.3"
}

@test "local file has precedence over global" {
  create_version "1.10.8"
  create_version "1.11.3"

  cat > "${HELMFILEENV_ROOT}/version" <<<"1.10.8"
  run helmfileenv-version-name
  assert_success "1.10.8"

  cat > ".helmfile-version" <<<"1.11.3"
  run helmfileenv-version-name
  assert_success "1.11.3"
}

@test "missing version" {
  HELMFILEENV_VERSION=1.2 run helmfileenv-version-name
  assert_failure "helmfileenv: version \`1.2' is not installed (set by HELMFILEENV_VERSION environment variable)"
}
