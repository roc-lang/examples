app "task-usage"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.5.0/Cufzl36_SnJ4QbOoEmiJ5dIpUxBvdB3NEySvuH82Wio.tar.br" }
    imports [
        pf.Stdout,
        pf.Stderr,
        pf.Task,
    ]
    provides [main] to pf

## A Task represents an effect—an interaction with state outside your Roc program,
## such as the terminal's standard output, or a file.

## A simple Task that always succeeds.
##
## A Task has two type parameters: the type of value it produces when it finishes running,
## and any errors that might happen when running it.
##
## The type `Task Str []` indicates that the success value of this task is
## `Str` and it cannot fail, so the error type is empty.
##
# TODO re-enable type definition once https://github.com/roc-lang/examples/issues/72 is fixed
# getName : Task Str []
getName = Task.ok "Sam"

## This task uses the `getName` task and combines the returned `Str` with the
## welcome message "Bonjour".
##
## We use `Task.map` to take the success value of the `getName` task, a `Str` and apply a function
## to it with type `Str -> Str`: `\name -> "Bonjour \(name)!"`.
##
## The type of `Task.map` is `Task a err, (a -> b) -> Task b err`.
## Filling this in for our case, this becomes: `Task Str [], (Str -> Str) -> Task Str []`
## In this case the type variables `a` and `b` are both `Str`, the types may be different but
## they don't need to be.
##
## Remember that `Task.map` is used to transform (= apply a function to) the success value of a Task.
##
## Next we use `Task.await` to print the new string to `Stdout`. This
## function takes the `Str` and returns a new `Task`.
##
## `Stdout.line` has the type `Str -> Task {} *`.
## The type of `Task.await` is `Task a err, (a -> Task b err) -> Task b err`.
## If we fill this in, we get: `Task Str [], (Str -> Task {} *) -> Task {} *`
## `Task.await` is used to create a new task with the success value of a given task.
# TODO re-enable type definition once https://github.com/roc-lang/examples/issues/72 is fixed
# printName : Task {} []
printName =
    getName
    |> Task.map (\name -> "Bonjour, \(name)!")
    |> Task.await (\welcomeStr -> Stdout.line welcomeStr)

## This task is similar to `getName` but it always fails and returns the
## error tag `Oops`.
# TODO re-enable type definition once https://github.com/roc-lang/examples/issues/72 is fixed
# alwaysFail : Task {} [Oops]
alwaysFail = Task.err Oops

## Here we use `Task.onErr` to create a new task if the previous one failed.
## In this case we are printing an error message to `Stdout`.
##
## The type of `Task.onErr` is `Task ok a, (a -> Task ok b) -> Task ok b`.
## If we fill this in, we get `Task {} [Oops], (Oops -> Task {} *) -> Task {} *`
##
## You can see the similarity with `Task.await`.
## With `Task.await` we create a new Task with the success value,
## and with `Task.onErr` we create a new Task with the failure value.
##
# TODO re-enable type definition once https://github.com/roc-lang/examples/issues/72 is fixed
# printErrorMessage : Task {} []
printErrorMessage =
    alwaysFail
    |> Task.onErr \err ->
        when err is
            Oops -> Stderr.line "An error happened!"

## This task will either fail or succeed depending on the Boolean value provided.
## If we review the type annotation, we can see that if this task succeeds it will
## return a tag union with a single tag, `Success`. If it fails it may return
## any one of three different tags.
##
## Note we are only using the `AnotherFail` tag here.
canFail : Bool -> Task.Task [Success] [Failure, AnotherFail, YetAnotherFail]
canFail = \shouldFail ->
    if shouldFail then
        Task.err AnotherFail
    else
        Task.ok Success

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
        Ok Success ->
            Stdout.line "Success!"

        Err Failure ->
            {} <- Stderr.line "Oops, failed!" |> Task.await
            Task.err 1 # 1 is an exit code to indicate failure

        Err AnotherFail ->
            {} <- Stderr.line "Oops, another failure!" |> Task.await
            Task.err 1

        Err YetAnotherFail ->
            {} <- Stderr.line "Really big oooooops, yet again!" |> Task.await
            Task.err 1
