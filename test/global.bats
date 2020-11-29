#!/usr/bin/env bats

load test_helper

@test "default" {
  run helmfileenv-global
  assert_success
  assert_output "system"
}

@test "read HELMFILEENV_ROOT/version" {
  mkdir -p "$HELMFILEENV_ROOT"
  echo "1.2.3" > "$HELMFILEENV_ROOT/version"
  run helmfileenv-global
  assert_success
  assert_output "1.2.3"
}

@test "set HELMFILEENV_ROOT/version" {
  mkdir -p "$HELMFILEENV_ROOT/versions/1.2.3/bin"
  run helmfileenv-global "1.2.3"
  assert_success
  run helmfileenv-global
  assert_success "1.2.3"
}

@test "fail setting invalid HELMFILEENV_ROOT/version" {
  mkdir -p "$HELMFILEENV_ROOT"
  run helmfileenv-global "1.2.3"
  assert_failure "helmfileenv: version \`1.2.3' is not installed"
}
