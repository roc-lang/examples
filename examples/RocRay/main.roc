### start snippet header
app [Model, program] {
	rr: platform "https://github.com/lukewilliamboswell/roc-ray/releases/download/0.10.0/5xecDmRJroKT9fnSiYsGdCKEzNWLnRKGtHJ5CxuCnpb9.tar.zst",
	roc: "nightly-2026-09-27-a3ce7f1",
}

### end snippet header

### start snippet example
import rr.App
import rr.Color
import rr.Draw

Model : { position : { x : F32, y : F32 }, pressed : Bool }

Msg : []

program = { init!, update!, render! }

init! : App.Init(Model, [])
init! = App.init(
	App.default.with_title("Follow the mouse").with_size({ width: 640, height: 480 }),
	|_io| Ok({ position: { x: 320, y: 240 }, pressed: False }),
)

update! : Model, App.Input(Msg), App.Io => Try(Model, [Exit(I64)])
update! = |_model, input, _io| Ok({
	position: input.devices.mouse.position(),
	pressed: input.devices.mouse.button_down(Left),
})

render! : Model, Draw.Frame => Try({}, [Exit(I64)])
render! = |model, frame| {
	frame.clear!(Color.black)
	frame.circle!({
		center: model.position,
		radius: 30,
		style: Draw.filled(
			if model.pressed {
				Color.red
			} else {
				Color.blue
			},
		),
	})
	Ok({})
}
### end snippet example
