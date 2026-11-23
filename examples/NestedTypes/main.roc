app [] {
	roc: "0.1.0-RC1",
}

### start snippet example
import Order

order = Order.new("Roc mug")

shipped = order.ship()

status : Order.Status
status = shipped.status

expect order.status == Order.Status.Pending
expect status == Order.Status.Shipped
expect shipped.item == "Roc mug"
### end snippet example
