#!/usr/bin/env bats

load test_helper

@test "without args shows summary of common commands" {
  run helmfileenv-help
  assert_success
  assert_line "Usage: helmfileenv <command> [<args>]"
  assert_line "Some useful helmfileenv commands are:"
}

@test "invalid command" {
  run helmfileenv-help hello
  assert_failure "helmfileenv: no such command \`hello'"
}

@test "shows help for a specific command" {
  mkdir -p "${HELMFILEENV_TEST_DIR}/bin"
  cat > "${HELMFILEENV_TEST_DIR}/bin/helmfileenv-hello" <<SH
#!shebang
# Usage: helmfileenv hello <world>
# Summary: Says "hello" to you, from helmfileenv
# This command is useful for saying hello.
echo hello
SH

  run helmfileenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfileenv hello <world>

This command is useful for saying hello.
SH
}

@test "replaces missing extended help with summary text" {
  mkdir -p "${HELMFILEENV_TEST_DIR}/bin"
  cat > "${HELMFILEENV_TEST_DIR}/bin/helmfileenv-hello" <<SH
#!shebang
# Usage: helmfileenv hello <world>
# Summary: Says "hello" to you, from helmfileenv
echo hello
SH

  run helmfileenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfileenv hello <world>

Says "hello" to you, from helmfileenv
SH
}

@test "extracts only usage" {
  mkdir -p "${HELMFILEENV_TEST_DIR}/bin"
  cat > "${HELMFILEENV_TEST_DIR}/bin/helmfileenv-hello" <<SH
#!shebang
# Usage: helmfileenv hello <world>
# Summary: Says "hello" to you, from helmfileenv
# This extended help won't be shown.
echo hello
SH

  run helmfileenv-help --usage hello
  assert_success "Usage: helmfileenv hello <world>"
}

@test "multiline usage section" {
  mkdir -p "${HELMFILEENV_TEST_DIR}/bin"
  cat > "${HELMFILEENV_TEST_DIR}/bin/helmfileenv-hello" <<SH
#!shebang
# Usage: helmfileenv hello <world>
#        helmfileenv hi [everybody]
#        helmfileenv hola --translate
# Summary: Says "hello" to you, from helmfileenv
# Help text.
echo hello
SH

  run helmfileenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfileenv hello <world>
       helmfileenv hi [everybody]
       helmfileenv hola --translate

Help text.
SH
}

@test "multiline extended help section" {
  mkdir -p "${HELMFILEENV_TEST_DIR}/bin"
  cat > "${HELMFILEENV_TEST_DIR}/bin/helmfileenv-hello" <<SH
#!shebang
# Usage: helmfileenv hello <world>
# Summary: Says "hello" to you, from helmfileenv
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run helmfileenv-help hello
  assert_success
  assert_output <<SH
Usage: helmfileenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
}
