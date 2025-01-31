module [
    hanoi,
]

State : {
    num_disks : U32, # number of disks in the Tower of Hanoi problem
    from : Str, # identifier of the source rod
    to : Str, # identifier of the target rod
    using : Str, # identifier of the auxiliary rod
    moves : List (Str, Str), # list of moves done so far
}

## Solves the Tower of Hanoi problem using recursion. Returns a list of moves
## which represent the solution.
hanoi : State -> List (Str, Str)
hanoi = |{ num_disks, from, to, using, moves }|
    if num_disks == 1 then
        List.concat(moves, [(from, to)])
    else
        moves1 = hanoi(
            {
                num_disks: (num_disks - 1),
                from,
                to: using,
                using: to,
                moves,
            },
        )

        moves2 = List.concat(moves1, [(from, to)])

        hanoi(
            {
                num_disks: num_disks - 1,
                from: using,
                to,
                using: from,
                moves: moves2,
            },
        )

start = { num_disks: 0, from: "A", to: "B", using: "C", moves: [] }

## Test Case 1: Tower of Hanoi with 1 disk
expect
    actual = hanoi({ start & num_disks: 1 })
    actual
    == [
        ("A", "B"),
    ]

## Test Case 2: Tower of Hanoi with 2 disks
expect
    actual = hanoi({ start & num_disks: 2 })
    actual
    == [
        ("A", "C"),
        ("A", "B"),
        ("C", "B"),
    ]

## Test Case 3: Tower of Hanoi with 3 disks
expect
    actual = hanoi({ start & num_disks: 3 })
    actual
    == [
        ("A", "B"),
        ("A", "C"),
        ("B", "C"),
        ("A", "B"),
        ("C", "A"),
        ("C", "B"),
        ("A", "B"),
    ]
