0 The canvas data needs to be accessible within Elm. In the current moment, I see two ways this can be done: 

  0.1 set and get functions talk directly to the canvas element and set and get the canvas data directly.

  0.2 The canvas data is also stored in the Elm model, and all modifications to it are also done to the canvas data stored in the canvas element itself.

  0.3 The first method (0.1) is technically simpler, and more performance. The second method (0.2) would probably be have more intuitive and readable code. The second method also has some inherent safety, as canvas elements are liable to being garbage collected, and when it is, its canvas data will be destroyed.

1 20170103. I think I need to start over. Things are coming together in my mind as I think about how this ought to work. I reviewed some of my own code, and some code by another developer, that perform flood fill operations on canvases. I realized that our method started first by actively grabbing the canvas data, and that worked perfectly well. I think method 0.1 in the point above is better, and not only is it better, but its not really mutually exclusive with method 0.2. One can get and set canvas data pretty directly, and also store that canvas data within ones model. Canvas.get can return a Maybe (Array Int), or a Maybe Canvas, and Canvas.set can just return the Canvas.

My new concern, is whether its okay to get canvas elements by id. It circumvents the Elm architecture, and therefore is a degressive and bad practice. It would be nice if there was a way to get and set canvas data without having the programmer manage string ids at all. Perhaps all of that can be maintained automatically behind the scenes. The canvas type alias can have a 'id' key, but that can be set automatically by the canvas package itself.

2 20170105. I implemented what I described in my previous discussion entry. It seems to work very well! I have a new question tho, how do I implement requestAnimationFrame? Currently, a canvas operation sets pixels on the canvas, and returns the entire canvas data. With requestAnimationFrame, you cannot return anything, or at least, not until the next animation frame. One sends a canvas operation to requestAnimationFrame, and forgets about it.

I suppose one could use requestAnimationFrame within Elm, and build and relieve a list of canvas operations that need to occur. That might work just find, but it could get tricky.

3 20170106 Today I implemented the load and draw image features. I basically followed the code from elm-community/webgl on texture loading. This really got me thinking! I realized I could store canvases and images as their own native data type. If there is a seperate data type of Image, that can be drawn onto canvases, dont I need separate functions like 'drawImage', which is separate from "draw" or "put"? If I have a canvas data type, doesnt that warrant new functions like "drawCanvas"? All of this challenges my current design. If I have canvas data types floating around, that natively contain canvas html objects, what does that mean for the toHtml function?