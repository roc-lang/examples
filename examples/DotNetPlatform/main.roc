app "dotnetapp"
    packages { platform: "./platform/main.roc" }
    imports []
    provides [main] to platform

main = "Hi from roc! (in a .NET platform) 🔥🦅🔥"
