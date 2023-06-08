app "task-usage"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.3.2/tE4xS_zLdmmxmHwHih9kHWQ7fsXtJr7W7h3425-eZFk.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
    ]
    provides [main] to pf

## This is a simple Task that always succeeds. From the type annotation, we can
## see that it returns a `Str` value and cannot fail as the error type is an
## empty tag uninon.
getName : Task.Task Str []
getName = Task.succeed "Louis"

## This task uses the `getName` task and combines the returned `Str` with the
## welcome message "Bonjour".
##
## We use `Task.map` to take the return value of the `Task` and apply the function
## `\name -> "Bonjour \(name)!"` to it. Note that this function has the type
## `Str -> Str`.
##
## Then we use `Task.await` to print the interpolated string to Stdout. This
## function takes the `Str` and returns a new `Task`.
##
## We know that `Stdout.line` has type `Str -> Task {} *` and `getName` cannot
## fail, therefore this task also cannot fail.
printName : Task.Task {} []
printName =
    getName
    |> Task.map \name -> "Bonjour \(name)!"
    |> Task.await \welcomeStr -> Stdout.line welcomeStr

## This task is similar to `getName` however it always fails and returns the
## tag `OopsSomethingBadHappened`.
alwaysFail : Task.Task {} [OopsSomethingBadHappened]
alwaysFail = Task.fail OopsSomethingBadHappened

## Here we use `Task.onFail` to run another task if the previous task fails.
## In this case we are printing a message to Stdout.
printErrorMessage : Task.Task {} []
printErrorMessage =
    alwaysFail
    |> Task.onFail \err ->
        when err is
            OopsSomethingBadHappened -> Stdout.line "Something error!"

## This task will either fail or succeed depending on the Boolean value provided.
## If we review the type annotation, we can see that if this task succeeds it will 
## return a tag union with a single tag, `Success`. If it fails it may return
## any one of three different tags. 
##
## Note we are only using the `AnotherFail` tag here.   
canFail : Bool -> Task.Task [Success] [Failure, AnotherFail, YetAnotherFail]
canFail = \shouldFail ->
    if shouldFail then
        Task.fail AnotherFail
    else
        Task.succeed Success

main =
    # Let's run our tasks in sequence, we can use `Task.await` and backpassing
    # syntax here because we know these tasks cannot fail, or if they do we
    # handle any errors.
    {} <- printName |> Task.await
    {} <- printErrorMessage |> Task.await

    # Here we know that the `canFail` task may fail, and so we can use
    # `Task.attempt` to convert the task to a `Result` and use then pattern 
    # matching to handle the succes and each of the possible failure cases.
    result <- canFail Bool.true |> Task.attempt
    when result is
        Ok Success -> Stdout.line "Success!"
        Err Failure -> Stdout.line "Oops, failed!"
        Err AnotherFail -> Stdout.line "Ooooops, another failure!"
        Err YetAnotherFail -> Stdout.line "Really big oooooops, yet again!"

