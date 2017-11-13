#!/bin/bash
set -e

__dir__="$(cd "$(dirname "$0")" && pwd)"

test_input_doesnt_exist() {
  local expected="Input file is missing"
  local actual="$($__dir__/cpp17csv doesnt-exist.csv c v o)"
  if [ "$expected" != "$actual" ]
  then
    echo "${FUNCNAME[0]} failed"
    echo "Expected: $expected"
    echo "Actual: $actual"
    exit 1
  fi
}

test_input_is_empty() {
  local expected="Input file is empty"
  local actual="$($__dir__/cpp17csv test-empty.csv c v o)"
  if [ "$expected" != "$actual" ]
  then
    echo "${FUNCNAME[0]} failed"
    echo "Expected: $expected"
    echo "Actual: $actual"
    exit 1
  fi
}

test_headers_exclude_column() {
  local expected="Column name doesn't exist in the input file"
  local actual="$($__dir__/cpp17csv test-input.csv zebra v o)"
  if [ "$expected" != "$actual" ]
  then
    echo "${FUNCNAME[0]} failed"
    echo "Expected: $expected"
    echo "Actual: $actual"
    exit 1
  fi
}

test_input_doesnt_exist
test_input_is_empty
test_headers_exclude_column
