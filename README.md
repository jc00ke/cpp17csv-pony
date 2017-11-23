# Expressive C++ 17 Coding Challenge, in Pony

This is my first foray into [Pony](https://www.ponylang.org/). Be gentle.

## Details on [the challenge](https://www.fluentcpp.com/2017/09/25/expressive-cpp17-coding-challenge/)

This command line tool should accept the following arguments:

* the filename of a CSV file,
* the name of the column to overwrite in that file,
* the string that will be used as a replacement for that column,
* the filename where the output will be written.

### Here is how to deal with edge cases:

#### if the input file is empty

- [x] the program should write “input file missing” to the console.
- [x] no output file generated

#### if the input file does not contain the specified column
- [x] the program should write “column name doesn’t exists in the input file” to the console.
- [x] no output file generated

#### if the program succeeds but there is already a file having the name specified for output
- [x] the program should overwrite this file.

## Setup

1. [Install Pony](https://github.com/ponylang/ponyc/blob/master/README.md#installation)
1. `make test`

## Running

`> ./cpp17csv test-input City London output.csv`
