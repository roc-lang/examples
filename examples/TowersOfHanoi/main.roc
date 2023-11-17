app "towers-of-hanoi"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        pf.Arg,
        Hanoi,
    ]
    provides [main] to pf

TaskErrors : [InvalidArg, InvalidNumStr]

main =
    task =
        args <- readArgs |> Task.await

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
        |> Task.ok

    taskResult <- Task.attempt task

    when taskResult is
        Ok result ->
            Stdout.line result

        Err InvalidArg ->
            {} <- Stdout.line "Error: Please provide the number of disks as an argument." |> Task.await

            Task.err 1 # 1 is an exit code to indicate failure

        Err InvalidNumStr ->
            {} <- Stdout.line "Error: Invalid number format. Please provide a positive integer." |> Task.await

            Task.err 1 # 1 is an exit code to indicate failure

readArgs : Task.Task { numDisks : U32 } TaskErrors
readArgs =
    Arg.list
    |> Task.mapErr \_ -> InvalidArg
    |> Task.await \args ->
        numDisksResult = List.get args 1 |> Result.try Str.toU32

        when numDisksResult is
            Ok numDisks ->
                if numDisks < 1 then
                    Task.err InvalidNumStr
                else
                    Task.ok { numDisks }

            _ -> Task.err InvalidNumStr
