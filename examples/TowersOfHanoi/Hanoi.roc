interface Hanoi
    exposes [
        hanoi,
    ]
    imports []

## Solves the Tower of Hanoi problem using recursion. Returns a list of moves
## which represent the solution.
hanoi :
    {
        numDisks : U32, # number of disks in the Tower of Hanoi problem
        from : Str, # identifier of the source rod
        to : Str, # identifier of the target rod
        using : Str, # identifier of the auxiliary rod
        moves : List (Str, Str), # list of moves accumulated so far
    }
    -> List (Str, Str)
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

start = { numDisks: 0, from: "A", to: "B", using: "C", moves: [] }

## Test Case 1: Tower of Hanoi with 1 disk
expect hanoi { start & numDisks: 1 } == [("A", "B")]

## Test Case 2: Tower of Hanoi with 2 disks
expect hanoi { start & numDisks: 2 } == [("A", "C"), ("A", "B"), ("C", "B")]

## Test Case 3: Tower of Hanoi with 3 disks
expect hanoi { start & numDisks: 3 } == [("A", "B"), ("A", "C"), ("B", "C"), ("A", "B"), ("C", "A"), ("C", "B"), ("A", "B")]
