app [main] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.10.0/vNe6s9hWzoTZtFmNkvEICPErI9ptji_ySjicO6CkucY.tar.br"
}

import pf.Stdout
import pf.Task

listOfNumbersUpto10 = List.range { start: At 1, end: At 10 }
numberToSearch = 5

main =
    listOfNumbersAsString = printPrettyList listOfNumbersUpto10
    numberExists = findInList listOfNumbersUpto10 numberToSearch
    if numberExists then
        Stdout.line! "$(Num.toStr numberToSearch) exists in $(listOfNumbersAsString)"
    else
        Stdout.line! "$(Num.toStr numberToSearch) does not exist in $(listOfNumbersAsString)"

printPrettyList: List U64 -> Str
printPrettyList = \list1 ->
   listToStr =
       list1
       |> List.map Num.toStr
       |> Str.joinWith ","
   "[$(listToStr)]"

# Find in list
findInList: List, U64 -> Bool
findInList = \list, val ->
    when list is
        [] -> Bool.false
        [head, .. as tail] ->
                if head == val then
                    Bool.true
                else
                    findInList tail val


## Test Case: Find the value in a list
expect findInList [1,2,3,4,5] 3 == Bool.true
expect findInList [1,2,3,4,5]  0 == Bool.false
expect findInList []  0 == Bool.false
