module []

### start snippet color
Color := [
    Red,
    Green,
    Blue,
]
    implements [
        Inspect { toInspector: color_inspector },
    ]

color_inspector : Color -> Inspector f where f implements InspectFormatter
color_inspector = \@Color color ->
    when color is
        Red -> Inspect.str "_RED_"
        Green -> Inspect.str "_GREEN_"
        Blue -> Inspect.str "_BLUE_"

expect Inspect.toStr (@Color Red) == "\"_RED_\""
expect Inspect.toStr (@Color Green) == "\"_GREEN_\""
expect Inspect.toStr (@Color Blue) == "\"_BLUE_\""
### end snippet color

### start snippet secret
MySecret := Str implements [
        Inspect { toInspector: my_secret_inspector },
    ]

my_secret_inspector : MySecret -> Inspector f where f implements InspectFormatter
my_secret_inspector = \@MySecret _ -> Inspect.str "******* REDACTED *******"

expect Inspect.toStr (@MySecret "password1234") == "\"******* REDACTED *******\""
### end snippet secret
