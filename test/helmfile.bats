#!/usr/bin/env bats

load test_helper

@test "blank invocation" {
  run helmfileenv
  assert_failure
  assert_line 0 "$(helmfileenv---version)"
}

@test "invalid command" {
  run helmfileenv does-not-exist
  assert_failure
  assert_output "helmfileenv: no such command \`does-not-exist'"
}

@test "default HELMFILEENV_ROOT" {
  HELMFILEENV_ROOT="" HOME=/home/mislav run helmfileenv root
  assert_success
  assert_output "/home/mislav/.helmfileenv"
}

@test "inherited HELMFILEENV_ROOT" {
  HELMFILEENV_ROOT=/opt/helmfileenv run helmfileenv root
  assert_success
  assert_output "/opt/helmfileenv"
}
