use "cli"

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
    let cs =
      try
        CommandSpec.leaf("cpp17csv",
            "Replaces the values in a column with a user defined value.",
            [], [
             ArgSpec.string("input", "Input CSV file")
             ArgSpec.string("column", "Column to be overwritten")
             ArgSpec.string("value", "Value to be used")
             ArgSpec.string("output", "Output CSV file")
            ])? .> add_help()?
      else
        env.exitcode(-1)
        return
      end
    let cmd =
      match CommandParser(cs).parse(env.args, env.vars())
      | let c: Command => c
      | let ch: CommandHelp =>
          ch.print_help(env.out)
          env.exitcode(0)
          return
      | let se: SyntaxError =>
          env.out.print(se.string())
          env.exitcode(1)
          return
      end

    let input = cmd.arg("input").string()
    let column = cmd.arg("column").string()
    let value = cmd.arg("value").string()
    let output = cmd.arg("output").string()

    env.out.print(input)
    env.out.print(column)
    env.out.print(value)
    env.out.print(output)
