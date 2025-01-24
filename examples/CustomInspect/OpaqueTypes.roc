module []

### start snippet color
Color := [
    Red,
    Green,
    Blue,
]
    implements [
        Inspect { to_inspector: color_inspector },
    ]

color_inspector : Color -> Inspector fmt where fmt implements InspectFormatter
color_inspector = |@Color(color)|
    when color is
        Red -> Inspect.str("_RED_")
        Green -> Inspect.str("_GREEN_")
        Blue -> Inspect.str("_BLUE_")

expect Inspect.to_str(@Color(Red)) == "\"_RED_\""
expect Inspect.to_str(@Color(Green)) == "\"_GREEN_\""
expect Inspect.to_str(@Color(Blue)) == "\"_BLUE_\""
### end snippet color

### start snippet secret
MySecret := Str implements [
        Inspect { to_inspector: my_secret_inspector },
    ]

my_secret_inspector : MySecret -> Inspector fmt where fmt implements InspectFormatter
my_secret_inspector = |@MySecret(_)| Inspect.str("******* REDACTED *******")

expect Inspect.to_str(@MySecret("password1234")) == "\"******* REDACTED *******\""
### end snippet secret
