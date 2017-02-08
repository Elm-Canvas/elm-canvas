# elm-community/canvas benchmarking

## Summary

These are pre-compiled tests to give get performance information on our canvas implementation. Try opening any of these html files in the browser of your choice to get performance information.

## Why are these pre-compiled?

Often, I use [elm-reactor](https://github.com/elm-lang/elm-reactor), but it defaults to using the debug window, which can be a significant hit to performance, because each step may contain various messages which all have to be rendered to complete the update call.

This isn't to discourage you from using elm-reactor, but for good data, make sure you remove the `?debug=true` from the urls that elm-reactor generates.

## Current performance data

### version 0.1.0

|                                              |Chrome 55 (OSX)  |Firefox (OSX)    |Safari (OSX)    |
|----------------------------------------------|-----------------|----------------|-----------------|
|01 Stress Test (500 at 800x600, 15 iterations)|3.805ms/rect     |6.899ms/rect    |2.664ms/rect     |
|02 Stress Test (500 at 800x600, 15 iterations)|3622.13ms/500rect|7535.8ms/500rect|3292.86ms/500rect|

### Contributing

Feel free to PR or create an issue with performance information on your browser and platform and we'll add it to the table.
