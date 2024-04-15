# kaomoji-generator

Generate random kaomoji! Useful for notifications, bars, and all other utilities for extra ╰( ͡° ͜ʖ ͡° )つ──☆*:・ﾟ .

## Usage

See `generate-kaomoji --help` or `nix run github:xav-ie/kaomoji-generator -- --help`:
```sh
generate-kaomoji --help
Usage: generate-kaomoji [options] [JQ filter]

Options:
  --help            Show this help message and exit
  -r, --raw-output  Output raw strings, not JSON texts
  [JQ filter]       Apply a custom jq filter to the selected kaomoji

Examples:

# generate a kaomoji object
> generate-kaomoji
{
  "category": "love",
  "value": "(*˘︶˘*).｡.:*♡"
}

# select the raw kaomoji string
> generate-kaomoji -r .value
(*˘︶˘*).｡.:*♡
```

## About

Kaomoji dataset scraped from kaomoji.ru.

The fork opts to use json instead as primary format. There was some duplicates removed from the original.

It is 757 kaomojis total at time of writing.

I think the selection on kaomoji.ru is good. There are some places that have excessive/useless kaomoji. This list may change over time to have less/more kaomoji that are more relevant.

## TODO

- [ ] support filtering by category
- [ ] allow flake to output raw json as an output
