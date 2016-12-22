# Canvas for Elm

Making the canvas API accessible within Elm. The canvas element is a very simple way to render 2D graphics.

## What is the canvas element?

The canvas element is a unique html element with mutable image data. By modification of the canvas elements data, the color value of individual pixels on the screen can be set. The basic definition of the canvas data type is..

``` Elm
  type alias Canvas =
    { width : Int
    , height : Int
    , data : List Int
    }
```

The data property is a list of color values in the canvas element, where the first four represent the red, green, blue, and alpha levels of the upper left most pixel, and the second four represent the rgba values of the pixel to the right of the upper left most, etc. The data property is always width * height * 4 long, Four ints for each pixel in the canvas.

```
  data = [ r0, g0, b0, a0, r1, g1, b1, a1, ... , rn, gn, bn, an ]
  for a canvas with n pixels, and where ri is the red value at pixel i. 
  
  Pixel i has the x and y coordinates of (i % width, i // width)
```

Width and height are the vertical and horizontal _resolutions_ of the canvas element, not the width and height of the element itself. To set the width and height, use the width and height style properties of the canvas element. If the width and height resolution dont match the width and height styles of the canvas element, then the pixels just wont be square.

To demonstrate how the canvas element works, lets consider an example where I need to set the pixel at x=50, y=20 to red (rgba = 255, 0, 0, 255) in a canvas 116 pixels wide and 333 pixels tall. I would set the data value at index (4 * 50) + (20 * 4 * 116) to 255, (4 * 50) + (20 * 4 * 116) + 1 to 0, (4 * 50) + (20 * 4 * 116) + 2 to 0, and (4 * 50) + (20 * 4 * 116) + 3 to 255. Thats 4 times the x position, plus 4 times the y position times the width, plus 0, 1, 2, or 3 for the red, green, blue, and alpha values respectively.

## When should you use Canvas?

Think hard before choosing to use the Elm Canvas library! For most use cases, there are probably better tools than Canvas. If you have image assets you want to move around the screen (like in a video game), then evancz/elm-graphics and elm-community/webgl are better options. You should use the canvas when you absolutely need to change pixel values at a very low level way, which is an unusual project requirement. If you are making a paint app then you should be using canvas, because you need to render image data, but the image data is determined at run time (unlike pre-existing images).

##Todo

0 Review this readme (I wrote it when I was very sleepy)

1 Rewrite the canvas.elm comments in a style consist with that of other elm modules

2 Keep making functions that satisfy the various needs a canvas programmer will have, and develope a technique of how canvas should be used in Elm.

3 the setPixels function takes a list of pixels, and draws them one at a time. It works fast enough, but for some sufficiently large list of pixels it wont be optimal. At some point, making a seperate image data with all the pixels and pasting it onto the canvas will work better.

4 Re-organize this repo so that there is a src folder only containing Native/Canvas.js and Canvas.elm, and an examples folder where uses of Canvas.elm are demonstrated.

##Concerns

0 Canvas data needs to be stored in the elm project seperately from the canvas data that exists within the canvas element itself. This violates the single source of truth principle. The canvas data must exist, and it therefore will exist outside of the elm frame work. To constantly update the canvas data from data within the elm framework is very un-performant. The data should exist within the elm frame work, for two reasons: 0 because the canvas element itself might disappear and if it does then its data will too; and 1 because some canvas operations are useful when they are functions of the existing data, (flood fill, and color inversion, for example). In this moment, I suppose the solution is to make an API that causes parrallel modification to the elm canvas data and the canvas data itself.


## MILESTONES
**20161213** Made a native elm module that returns a canvas element with a red square on it

**20161216** Elm-Canvas now contains a function called canvas, which takes a width, height, and list of canvas data, and returns a canvas with that data. 

**20161217** setPixels function, which given a list of (Coordinate, Color), changes the pixels at those coordinates on a specific canvas to those colors
