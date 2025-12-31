app [main!] { pf: platform "../platform/main.roc" }

import pf.Stdout

# Minimal example demonstrating encoding with static dispatch
# For a more advanced example with custom types, see EncodeDecodeAdvanced

# Define a simple JSON-like format type with the required methods
JsonFormat := [Format].{
    # Method required by Str.encode where clause
    encode_str : JsonFormat, Str -> Try(List(U8), [])
    encode_str = |_fmt, str| {
        quoted = "\"${str}\""
        Ok(Str.to_utf8(quoted))
    }

    # Method required by List.encode where clause
    encode_list : JsonFormat, List(item), (item, JsonFormat -> Try(List(U8), err)) -> Try(List(U8), err)
    encode_list = |fmt, items, encode_item| {
        var $result = ['[']
        var $first = Bool.True
        
        for item in items {
            if $first {
                $first = Bool.False
            } else {
                $result = $result.append(',')
            }
            match encode_item(item, fmt) {
                Ok(encoded) => $result = $result.concat(encoded)
                Err(e) => return Err(e)
            }
        }
        
        Ok($result.append(']'))
    }
}

main! : List(Str) => Try({}, [Exit(I32)])
main! = |_args| {
    json_fmt = JsonFormat.Format
    
    # Encode a string
    hello = "Hello, World!"
    encoded = hello.encode(json_fmt)?
    
    Stdout.line!("Encoded string:")
    Stdout.line!("  Input: ${hello}")
    
    match Str.from_utf8(encoded) {
        Ok(json) => Stdout.line!("  As JSON: ${json}")
        Err(_) => Stdout.line!("  (invalid UTF-8)")
    }
    
    Stdout.line!("")
    
    # Encode a list of strings
    names = ["Alice", "Bob", "Charlie"]
    encoded_list = names.encode(json_fmt)?
    
    Stdout.line!("Encoded list:")
    Stdout.line!("  Input: [\"Alice\", \"Bob\", \"Charlie\"]")
    
    match Str.from_utf8(encoded_list) {
        Ok(json) => Stdout.line!("  As JSON: ${json}")
        Err(_) => Stdout.line!("  (invalid UTF-8)")
    }
    
    Ok({})
}
