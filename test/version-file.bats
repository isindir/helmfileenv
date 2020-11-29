#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "$HELMFILEENV_TEST_DIR"
  cd "$HELMFILEENV_TEST_DIR"
}

create_file() {
  mkdir -p "$(dirname "$1")"
  echo "system" > "$1"
}

@test "detects global 'version' file" {
  create_file "${HELMFILEENV_ROOT}/version"
  run helmfileenv-version-file
  assert_success "${HELMFILEENV_ROOT}/version"
}

@test "prints global file if no version files exist" {
  assert [ ! -e "${HELMFILEENV_ROOT}/version" ]
  assert [ ! -e ".helmfile-version" ]
  run helmfileenv-version-file
  assert_success "${HELMFILEENV_ROOT}/version"
}

@test "in current directory" {
  create_file ".helmfile-version"
  run helmfileenv-version-file
  assert_success "${HELMFILEENV_TEST_DIR}/.helmfile-version"
}

@test "in parent directory" {
  create_file ".helmfile-version"
  mkdir -p project
  cd project
  run helmfileenv-version-file
  assert_success "${HELMFILEENV_TEST_DIR}/.helmfile-version"
}

@test "topmost file has precedence" {
  create_file ".helmfile-version"
  create_file "project/.helmfile-version"
  cd project
  run helmfileenv-version-file
  assert_success "${HELMFILEENV_TEST_DIR}/project/.helmfile-version"
}

@test "HELMFILEENV_DIR has precedence over PWD" {
  create_file "widget/.helmfile-version"
  create_file "project/.helmfile-version"
  cd project
  HELMFILEENV_DIR="${HELMFILEENV_TEST_DIR}/widget" run helmfileenv-version-file
  assert_success "${HELMFILEENV_TEST_DIR}/widget/.helmfile-version"
}

@test "PWD is searched if HELMFILEENV_DIR yields no results" {
  mkdir -p "widget/blank"
  create_file "project/.helmfile-version"
  cd project
  HELMFILEENV_DIR="${HELMFILEENV_TEST_DIR}/widget/blank" run helmfileenv-version-file
  assert_success "${HELMFILEENV_TEST_DIR}/project/.helmfile-version"
}

@test "finds version file in target directory" {
  create_file "project/.helmfile-version"
  run helmfileenv-version-file "${PWD}/project"
  assert_success "${HELMFILEENV_TEST_DIR}/project/.helmfile-version"
}

@test "fails when no version file in target directory" {
  run helmfileenv-version-file "$PWD"
  assert_failure ""
}
