app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout

# Local Dispatch Example
# ======================
# The `->` operator passes the left-hand value as the first argument
# to a function in local scope. This replaces the pizza operator `|>`
# for functions that aren't methods on the type.

# Define some helper functions
double : I64 -> I64
double = |n| n * 2

add_ten : I64 -> I64
add_ten = |n| n + 10

square : I64 -> I64
square = |n| n * n

# String helper
wrap_parens : Str -> Str
wrap_parens = |s| "(${s})"

# You can chain local dispatch calls
chain_math : I64 -> I64
chain_math = |n|
    n->double->add_ten->square

# Mix method syntax and local dispatch
format_number : I64 -> Str
format_number = |n|
    n.to_str()->wrap_parens

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    # Basic local dispatch: value->function
    # This is equivalent to: double(5)
    result1 = 5->double
    Stdout.line!("5->double = ${result1.to_str()}")
    
    # Chain multiple local dispatch calls
    # This is equivalent to: square(add_ten(double(3)))
    result2 = 3->double->add_ten->square
    Stdout.line!("3->double->add_ten->square = ${result2.to_str()}")
    
    # Using the helper function
    result3 = chain_math(2)
    Stdout.line!("chain_math(2) = ${result3.to_str()}")
    
    # Mix method syntax (.method) with local dispatch (->func)
    # Method syntax: calls a method defined on the type
    # Local dispatch: calls a function in local scope
    formatted = 42->format_number
    Stdout.line!("42->format_number = ${formatted}")
    
    # Compare the styles:
    Stdout.line!("")
    Stdout.line!("Style comparison:")
    
    # Traditional function call (nested, reads inside-out)
    traditional = square(add_ten(double(7)))
    Stdout.line!("  square(add_ten(double(7))) = ${traditional.to_str()}")
    
    # Local dispatch (chained, reads left-to-right)
    arrow_style = 7->double->add_ten->square
    Stdout.line!("  7->double->add_ten->square = ${arrow_style.to_str()}")
    
    # Both produce the same result!
    
    Ok({})
}
