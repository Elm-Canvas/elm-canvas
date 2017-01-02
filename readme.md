# Canvas for Elm

Making the canvas API accessible within Elm. The canvas element is a very simple way to render 2D graphics.

## What is the canvas element?

The canvas element is a unique html element that contains image data. The canvas element presents its image data, and by modification to the canvas elements image data you can change what is rendered. 

The canvas element has three properties, width, height, and data. The width and height are the resolution of the canvas- NOT the actual dimensions of the canvas. To set the width and height of a canvas, one must set the width and height properties in the style of the element. If the styles width and the canvass width are not equal, the pixels wont be rendered as perfeclty square.

The data property of the canvas element is the color information in the canvas. Its a little tricky to explain, but straight forward once you understand it. The data property is an array of numbers. Each number is a color value for a pixel. The first four numbers are the red, green, blue, and alpha values of the first pixel (the one in the upper left most corner). The next four are the red, green, blue, and alpha values for the next pixel, which is the pixel to the right of the first pixel.

``` Elm
  --  canvas thats three pixels wide and two pixels tall :

  --       |       | 
  --   red | white | red
  --       |       | 
  --  -------------------
  --       |       | 
  --   red | black | black
  --       |       |

  data =
  --  first pixel (red)        second pixel (white)     third pixel (red)
    [ 255,   0,    0, 255,     255, 255,  255, 255,     255, 255,  255, 255
  --  fourth pixel (red)      fifth pixel (black)       sixth pixel (black)
    , 255,   0,    0, 255,       0,   0,    0, 255,       0,   0,   0,  255
  --  red  green blue alpha    red  green blue alpha    red  green blue alpha
    ]

```

Because every pixel is four numbers long, and every canvas has width * height pixels, every canvas data has a length of 4 * width * height

Because the data is a one dimensional format of a two dimensional arrangement of pixels, to change the pixel at x=50 y=20 of a 116 x 55 canvas (where x=0 y=0 is the upper left corner), one must change the values at indices.. 

```
((50 + (20 * 116)) * 4)
((50 + (20 * 116)) * 4) + 1
((50 + (20 * 116)) * 4) + 2
((50 + (20 * 116)) * 4) + 4

(x + (y * width)) * 4
```

## When should you use Canvas?

Think hard before choosing to use the Elm Canvas library! For most use cases, there are probably better tools than Canvas. If you have image assets you want to move around the screen (like in a video game), then evancz/elm-graphics and elm-community/webgl are better options. You should use the canvas when you absolutely need to change pixel values in a very low level way, which is an unusual project requirement. Generally speaking, the canvas element should be used when you need to render images that are not defined until run time. Making a paint app is an example of a project that needs a canvas element.

##Todo

~~0 Review this readme (I wrote it when I was very sleepy)~~

1 Rewrite the canvas.elm comments in a style consist with that of other elm modules

2 develop a technique of how canvas should be used in Elm

~~3 Make a pasteCanvas or pasteImage function.~~ putImageData implemented but its very sloooooooow

4 use requestAnimationFrame for performance

5 make a paste image function

6 make a crop image function

7 test pasting images around in different spots

##Concerns

0 Canvas data needs to be stored in the elm project seperately from the canvas data that exists within the canvas element itself. This violates the single source of truth principle. The canvas data must exist, and it therefore will exist outside of the elm frame work. To constantly update the canvas data from data within the elm framework is very un-performant. The data should exist within the elm frame work, for two reasons: 0 because the canvas element itself might disappear and if it does then its data will too; and 1 because some canvas operations are useful when they are functions of the existing data, (flood fill, and color inversion, for example). In this moment, I suppose the solution is to make an API that causes parrallel modification to the elm canvas data and the canvas data itself.


## MILESTONES
**20161213** Made a native elm module that returns a canvas element with a red square on it

**20161216** Elm-Canvas now contains a function called canvas, which takes a width, height, and list of canvas data, and returns a canvas with that data. 

**20161217** setPixels function, which given a list of (Coordinate, Color), changes the pixels at those coordinates on a specific canvas to those colors
