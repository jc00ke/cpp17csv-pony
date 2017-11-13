#!/bin/bash
set -e

__dir__="$(cd "$(dirname "$0")" && pwd)"

test_input_doesnt_exist() {
  local output="$($__dir__/cpp17csv doesnt-exist.csv c v o)"
  if [ "Input file is missing" != "$output" ]
  then
    echo "${FUNCNAME[0]} failed"
    echo "Expected: Input file is missing"
    echo "Actual: $output"
    exit 1
  fi
}

test_input_is_empty() {
  local output="$($__dir__/cpp17csv test-empty.csv c v o)"
  if [ "Input file is empty" != "$output" ]
  then
    echo "${FUNCNAME[0]} failed"
    echo "Expected: Input file is empty"
    echo "Actual: $output"
    exit 1
  fi
}

test_input_doesnt_exist
