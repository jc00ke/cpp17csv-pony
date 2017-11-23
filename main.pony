use "debug"
use "cli"
use "files"

type CsvIndex is ((USize, String) | None)
type CsvExists is (FileExists | None)

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

      match handle_missing_input(env, path, input)
      | None => return
      end
      """
      Will the file be disposed of when using match?
      https://github.com/ponylang/ponyc/blob/master/examples/files/files.pony
      """
      match OpenFile(path)
      | let file: File if file.size() == 0 =>
        handle_empty_file(env)
      | let file: File =>
        match index_of_header_column(file, column)
        | None =>
          handle_missing_column(env)
        | (let index: USize, let header: String) =>
          write_output_file(file, index, header, env, value, output)?
        end
      else
        env.out.print("Unknown error")
        env.exitcode(500)
      end
    end

  fun handle_missing_input(env: Env, path: FilePath, input: String) : CsvExists =>
    if not path.exists() then
      env.out.print("Input file is missing")
      env.exitcode(404)
      return None
    end
    FileExists


  fun write_output_file(file: File, index: USize, header: String, env: Env, value: String, output: String) ? =>
    let output_path = FilePath(env.root as AmbientAuth, output)?
    let lines = FileLines.create(file)
    with file' = CreateFile(output_path) as File do
      file'.print(header)
      while lines.has_next() do
        let line = lines.next()
        var values = recover ref line.split(",") end
        values.update(index, value)?
        let new_line = ",".join(values.values()) as String
        file'.print(new_line)
      end
    end

  fun handle_missing_column(env: Env) =>
    env.out.print("Column name doesn't exist in the input file")
    env.exitcode(412)

  fun handle_empty_file(env: Env) =>
    env.out.print("Input file is empty")
    env.exitcode(411)

  fun index_of_header_column(file: File, column: String): CsvIndex =>
    try
      let line = recover val file.line()? end
      let columns = line.split(",")
      let p = {(l: String, r: String): Bool => l.eq(r)}
      let index = columns.find(column where predicate = p)?
      (index, line)
    else
      None
    end
