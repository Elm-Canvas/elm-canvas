# Canvas for Elm

Making the canvas API accessible within Elm. The canvas element is a very simple way to render 2D graphics.

# Getting started

Check out the examples in this repo. As of January 8th 2017, they dont work in elm-reactor, sorry, but they work fine in compiled Elm.

# How does this work?

This code ..

``` Elm
import Canvas
import Color


main =
  Canvas.initialize 400 300
  |> Canvas.fill (Color.rgb 23 92 254)
  |> Canvas.toHtml []


```

.. renders as ..

![alt text](http://i.imgur.com/idJXHTP.png "Simple Canvas Render")


The Elm-Canvas library provides the type `Canvas`, which can be passed around, modified, drawn on, pasted, and ultimately passed into `toHtml` where they are rendered.


## What is the canvas element?

The canvas element is a unique html element that contains something called image data. The canvas element renders its image data, and by modification of its image data you can change what is rendered. This library provides an API to modify and set canvas image data.

The canvas element itself has three properties: width, height, and data. Confusingly, the width and height are the resolution of the canvas- NOT the actual dimensions of the canvas. To set the width and height of a canvas, one must set the width and height properties in the style of the element. If the styles width and the canvass width are not equal, the pixels wont be rendered as perfeclty square.

The data property of the canvas element is the color information in the canvas. The data property is an array of numbers. Each number is a color value for a specific pixel. The first four numbers in that array are the red, green, blue, and alpha values of the first pixel, and the next four are the red, green, blue, and alpha values for the second pixel, which is the pixel to the right of the first pixel (and the first pixel is the upper left most one).

``` Elm
  --  A canvas thats three pixels wide and two pixels tall..

  --       |       | 
  --   red | white | red
  --       |       | 
  --  -------------------
  --       |       | 
  --   red | black | black
  --       |       |

  -- ..has the following data..

  data == fromList
    [ 255, 0, 0, 255,    255, 255, 255, 255,    255, 0, 0, 255
    , 255, 0, 0, 255,    0, 0, 0, 255,          0, 0, 0, 0
    ] 

```

Because every pixel is four numbers long, and every canvas has width * height pixels, every canvas data has a length of 4 * width * height

Because the data is a one dimensional format of a two dimensional arrangement of pixels, to change the pixel at x=50 y=20 of a 116 x 55 canvas (where x=0 y=0 is the upper left corner), one must change the values at indices.. 

```
((50 + (20 * 116)) * 4)
((50 + (20 * 116)) * 4) + 1
((50 + (20 * 116)) * 4) + 2
((50 + (20 * 116)) * 4) + 3


((x + (y * width)) * 4) + (colorIndex)
```

## When should you use Canvas?

Think hard before choosing to use the Elm Canvas library! For most use cases, there are probably better tools than Canvas. If you have image assets you want to move around the screen (like in a video game), then [evancz/elm-graphics](https://github.com/evancz/elm-graphics) and [elm-community/webgl](https://github.com/elm-community/webgl) are better options. If you want to render vector graphics use [elm-svg](http://package.elm-lang.org/packages/elm-lang/svg/latest). You should use the canvas when you absolutely need to change pixel values in a very low level way, which is an unusual project requirement. Generally speaking, the canvas element should be used when you need to render raster graphics that are not defined until run time. Making a paint app is an example of a project that needs a canvas element, because the purpose of a drawing app is to make graphics that do not yet exist.



