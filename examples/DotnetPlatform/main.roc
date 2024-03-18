app "dotnetapp"
    packages { platform: "./platform/roc_platform.roc" }
    imports []
    provides [main] to platform

main = "Hi from roc! (in a .NET platform) 🔥🦅🔥"
