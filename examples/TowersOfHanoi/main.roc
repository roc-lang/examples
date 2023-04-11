app "example"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.1/97mY3sUwo433-pcnEQUlMhn-sWiIf_J9bPhcAFZoqY4.tar.br" }
    imports [
        pf.Stdout,
        pf.Task.{ await },
        pf.Arg,
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
        |> hanoi
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

## Solves the Tower of Hanoi problem using recursion.
##
## `numDisks` - The number of disks in the Tower of Hanoi problem.
## `from` - The identifier of the source rod.
## `to` - The identifier of the target rod.
## `using` - The identifier of the auxiliary rod.
## `moves` - A list of moves accumulated so far.
##
## Returns a list of moves (tuples) to solve the Tower of Hanoi problem.
##
hanoi = \{ numDisks, from, to, using, moves } ->
    if numDisks == 1 then
        List.concat moves [(from, to)]
    else
        moves1 = hanoi {
            numDisks: (numDisks - 1),
            from,
            to: using,
            using: to,
            moves,
        }

        moves2 = List.concat moves1 [(from, to)]

        hanoi {
            numDisks: (numDisks - 1),
            from: using,
            to,
            using: from,
            moves: moves2,
        }

tc = { numDisks: 1, from: "A", to: "B", using: "C", moves: [] }

## Test Case 1: Tower of Hanoi with 1 disk
expect hanoi { tc & numDisks: 1 } == [("A", "B")]

## Test Case 2: Tower of Hanoi with 2 disks
expect hanoi { tc & numDisks: 2 } == [("A", "C"), ("A", "B"), ("C", "B")]

## Test Case 3: Tower of Hanoi with 3 disks
expect hanoi { tc & numDisks: 3 } == [("A", "B"), ("A", "C"), ("B", "C"), ("A", "B"), ("C", "A"), ("C", "B"), ("A", "B")]
