app "towers-of-hanoi"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ await },
        pf.Arg,
        Hanoi,
    ]
    provides [main] to pf

TaskErrors : [InvalidArg, InvalidNumStr]

main =
    task =
        args <- readArgs |> await

        {
            numDisks: args.numDisks,
            from: "A",
            to: "B",
            using: "C",
            moves: [],
        }
        |> Hanoi.hanoi
        |> List.map \(from, to) -> "Move disk from \(from) to \(to)"
        |> Str.joinWith "\n"
        |> Task.succeed

    taskResult <- Task.attempt task

    when taskResult is
        Ok result -> Stdout.line result
        Err InvalidArg -> Stdout.line "Error: Please provide the number of disks as an argument."
        Err InvalidNumStr -> Stdout.line "Error: Invalid number format. Please provide a positive integer."

readArgs : Task.Task { numDisks : U32 } TaskErrors
readArgs =
    Arg.list
    |> Task.mapFail \_ -> InvalidArg
    |> await \args ->
        numDisksResult = List.get args 1 |> Result.try Str.toU32

        when numDisksResult is
            Ok numDisks ->
                if numDisks < 1 then
                    Task.fail InvalidNumStr
                else
                    Task.succeed { numDisks }

            _ -> Task.fail InvalidNumStr

