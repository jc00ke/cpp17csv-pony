actor Main
  """
  More specifically, this command line tool should accept the following arguments:

  - the filename of a CSV file,
  - the name of the column to overwrite in that file,
  - the string that will be used as a replacement for that column,
  - the filename where the output will be written.

  Here is how to deal with edge cases:

  - if the input file is empty
    [ ] the program should write “input file missing” to the console.
    [ ] no output file generated
  - if the input file does not contain the specified column
    [ ] the program should write “column name doesn’t exists in the input file” to the console.
    [ ] no output file generated
  - if the program succeeds but there is already a file having the name specified for output
    [ ] the program should overwrite this file.
  """

  new create(env: Env) =>
    env.out.print("Do something")
