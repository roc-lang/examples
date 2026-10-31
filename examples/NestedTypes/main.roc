app [] {
	roc: "nightly-2026-10-31-f7bef6b",
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
