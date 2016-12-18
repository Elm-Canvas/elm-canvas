# THIS IS ELM CANVAS

I would like to make the canvas element accessible within Elm, a front end ml syntax language that compiles to JavaScript. By accessible, I mean make the API available within Elm, so that one can specify canvas data, and pixel colors, within the Elm architecture.

## MILESTONES
**20161213** Made a native elm module that returns a canvas element with a red square on it

**20161216** Elm-Canvas now contains a function called canvas, which takes a width, height, and list of canvas data, and returns a canvas with that data. 

**20161217** putPixels function, which given a list of (Coordinate, Color), changes the pixels at those coordinates on a specific canvas to those colors

## GOALS
0 ~~Make a function that can return a canvas with given canvas data~~

1 Make a library that can efficiently modify canvas data, however sophisticated the API might be