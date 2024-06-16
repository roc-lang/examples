app [main] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br" }

import pf.Stdout
import pf.Task

listOfNumbersUpto10 = List.range { start: At 1, end: At 10 }

main =
    Stdout.line! "List $(printPrettyList listOfNumbersUpto10) has a length of $(Num.toStr(lengthOfList listOfNumbersUpto10))"

    Stdout.line! "$(findInList listOfNumbersUpto10 5 0) in the list $(printPrettyList listOfNumbersUpto10)"

printPrettyList: List U64 -> Str
printPrettyList = \list1 ->
   listToStr = List.map list1 Num.toStr
                |> Str.joinWith ","
   "[$(listToStr)]"

## Find the lenght of a list
lengthOfList : List U64 -> U64
lengthOfList = \list ->
    when list is
        [] -> 0
        [_, .. as tail] -> 1 + lengthOfList tail

# Find in list
findInList: List, U64, U64 -> Str
findInList = \list, val, index ->
    when list is
        [] -> "$(Num.toStr val) not found"
        [head, .. as tail] -> if head == val then "$(Num.toStr val) found at index $(Num.toStr index)" else findInList tail val (index+1)

## Test Case 1: Length of an empty List & non-empty List
expect lengthOfList [] == 0
expect lengthOfList [1,2,3] == List.len [1,2,3]
