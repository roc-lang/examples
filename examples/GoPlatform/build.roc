app "build-platform-prebuilt-binaries"
    packages {
        cli: "../../../basic-cli/platform/main.roc",
    }
    imports [
        cli.Stdout,
        cli.Cmd,
        cli.Task.{ Task },
    ]
    provides [main] to cli

SupportedTarget : [
    MacosArm64,
    MacosX64,
    LinuxArm64,
    LinuxX64,
    WindowsArm64,
    WindowsX64,
]

main =

    buildGoTarget! MacosArm64

    # TODO -- why is this failing with "build constraints exclude all Go files"?
    buildGoTarget! MacosX64 

    # buildGoTarget! LinuxArm64
    # etc
    
    Stdout.line "DONE"

buildGoTarget : SupportedTarget -> Task {} _
buildGoTarget = \target -> 

    (goos, goarch, prebuiltBinary) = when target is
        MacosArm64 -> ("darwin", "arm64", "macos-arm64.a")
        MacosX64 -> ("darwin", "amd64", "macos-x64")
        LinuxArm64 -> ("linux", "arm64", "linux-arm64.a")
        LinuxX64 -> ("linux", "amd64", "linux-x64.a")
        WindowsArm64 -> ("windows", "arm64", "windows-arm64.a")
        WindowsX64 -> ("windows", "amd64", "windows-x64")

    Cmd.new "go"
    |> Cmd.envs [("GOOS", goos), ("GOARCH", goarch)]
    |> Cmd.args ["build", "-C", "host", "-buildmode=c-archive", "-o","libhost.a"]
    |> Cmd.status
    |> Task.mapErr! \err -> BuildErr goos goarch (Inspect.toStr err)

    Cmd.exec "cp" ["host/libhost.a", "platform/$(prebuiltBinary)"]
    |> Task.mapErr! \err -> CpErr (Inspect.toStr err)