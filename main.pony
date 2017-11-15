use "debug"
use "cli"
use "files"

type CsvIndex is (USize | None)

actor Main
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

    try
      let path = FilePath(env.root as AmbientAuth, input)?
      if not path.exists() then
        env.out.print("Input file is missing")
        env.exitcode(404)
        return
      end
      """
      Will the file be disposed of when using match?
      https://github.com/ponylang/ponyc/blob/master/examples/files/files.pony
      """
      match OpenFile(path)
      | let file: File if file.size() == 0 =>
        env.out.print("Input file is empty")
        env.exitcode(411)
        return
      | let file: File =>
        match index_of_header_column(file, column)
        | None =>
          env.out.print("Column name doesn't exist in the input file")
          env.exitcode(412)
          return
        | let index: USize =>
          env.out.print("First line contains: " + column + " at " + index.string())
        end
        return
      else
        env.out.print("Unknown error")
        env.exitcode(500)
        return
      end
    end
    env.out.print(input)
    env.out.print(column)
    env.out.print(value)
    env.out.print(output)

  fun index_of_header_column(file: File, column: String): CsvIndex =>
    try
      let line = file.line()?
      let columns = line.split(",")
      columns.find(column)?
    else
      None
    end
