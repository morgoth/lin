# Lin

Parser for contract bridge board "lin" notation, that is used on BBO.

## Usage

```
parser = Lin::Parser.new("lin-content-here")
parser.bids
#=> ["1H", "PASS", "PASS", "PASS"]
```

## TODO

* Retrieve alerts
