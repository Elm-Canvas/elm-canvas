🚨🚨THIS IS EXPERIMENTAL.🚨🚨 

We are trying to make this package reliable, and for all we know it is, but we havent used it nearly enough to know for sure. Use are your own risk. If you do discover problems please let us know, it would be really useful.

# Canvas for Elm

Making the canvas API accessible within Elm. The canvas element is a very simple way to render 2D graphics.

# Whats this all this about?

This code ..

``` elm
import Html exposing (Html)
import Canvas exposing (Size, Point, Canvas, DrawOp(..), Style)
import Color

main : Html a
main =
    Canvas.toHtml [] blueRectangle


blueRectangle : Canvas
blueRectangle =
    let
        size : Size
        size =
            { width = 400
            , height =  300
            }
    in
        Canvas.initialize size
            |> Canvas.draw (fillBlue size)


fillBlue : Size -> DrawOp
fillBlue size =
    [ FillStyle (Canvas.Color Color.blue)
    , FillRect (Point 0 0) size
    ]
        |> Canvas.batch


-- Canvas.batch : List DrawOp -> DrawOp
-- Canvas.draw : DrawOp -> Canvas -> Canvas
-- Canvas.toHtml : List (Attribute a) -> Canvas -> Html a
```

.. renders as ..

![alt text](http://i.imgur.com/SruZuvZ.png "Simple Canvas Render")


The Elm-Canvas library provides the type `Canvas`, which can be passed around, modified, drawn on, pasted, and ultimately passed into `toHtml` where they are rendered.

Almost all the properties and methods of the 2d canvas context are available in Elm-Canvas. [Understanding them is necessary for full useage of this package.](https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D)


## What is the Canvas Element?

[The mozilla developer network has the best answer to this question.](https://developer.mozilla.org/en-US/docs/Web/API/Canvas_API) But basically, the canvas element is a unique html element that contains something called image data. The canvas element renders its image data, and by modification of its image data you can change what is rendered. This library provides an API to modify and set canvas image data.


## When should you use Elm-Canvas?

We made this package for a some really unusual use cases, which likely arent your use case. Think hard before choosing to use Elm-Canvas, you probably dont need it. If you have image assets you want to move around the screen (like in a video game), then [evancz/elm-graphics](https://github.com/evancz/elm-graphics) and [elm-community/webgl](https://github.com/elm-community/webgl) are better options. If you want to render vector graphics use [elm-svg](http://package.elm-lang.org/packages/elm-lang/svg/latest). You should use the canvas when you absolutely need to change pixel values in a very low level way, which is an unusual project requirement.

In making this package, we had various design considerations. On one hand we wanted to make things clearer and simpler than the native canvas API actually is (theres a lot of room for improvement on that front). On the other hand, the use cases we had in mind for Elm-Canvas are some what broad. For Elm-Canvas, we are just trying to expose as much of the native canvas API as we can into Elm. Elm-Canvas makes no presumption about a what your specific use case is, but we figure direct access to the canvas api will help you get to where you need.

## Contributing

Pull requests, and general feedback welcome. I am in the `#canvas` channel in the [Elm Slack](https://elmlang.slack.com).

## Thanks

Thanks to [Alex](https://github.com/mrozbarry) for contributing to this project, but also for his feedback and insights into what an Elm canvas API needs to look like, which have been instrumental in the development of Elm-Canvas. Thanks to the authors of the [Elm Web-Gl package](https://github.com/elm-community/webgl) for writing really readable code, which I found very educational on how to make native Elm packages. Thanks to all the helpful and insightful people in the Elm slack channel, including [Alex Spurling](https://github.com/alexspurling), the maker of [this elm app called 'quick draw'](https://github.com/alexspurling). Thanks to [mdgriffin](https://github.com/mdgriffith), [Noah Gordon](https://github.com/noahzgordon), and all the other nice people at the Elm NYC meet up who had great feedback for this project.. 

## How to use Elm-Canvas in your project

Elm-Canvas is a native module, which means you cant install it from package.elm-lang.org. You can still use this module in your project, but it will take a little work. One way to install it, is to use [elm-github-install](https://github.com/gdotdesign/elm-github-install). You can do it manually too, like this..

0 Download either this repo, or better yet, one of the tagged releases (like 0.1.0).

1 Copy the content of `./src` into the source directory of your project. So that means copying `./src/Canvas.elm` and `./src/Native/` to the same directory as your `Main.elm` file.

2 Open up `Native/Canvas.js`. The first line says `var _elm_canvas$elm_canvas$Native_Canvas = function () {`. In your `elm-package.json` file, you have a repo field. In that first line of `Native/Canvas.js`, replace the first `elm_canvas` with the user name from the `elm-package.json`s repo, and replace the second `elm_canvas` with the project name in your repo field. So if your elm package lists `"repository": "https://github.com/ludwig/art-project.git"`, change the first line of `Native/Canvas.js` to `var _ludwig$art_project$Native_Canvas = function () {`.

3 Add the line `"native-modules": true,` to your elm package file.

## License

The source code for this package is released under the terms of the BSD3 license. See the `LICENSE` file.



