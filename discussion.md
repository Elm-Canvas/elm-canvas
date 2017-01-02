0 The canvas data needs to be accessible within Elm. In the current moment, I see two ways this can be done: 

  0.1 set and get functions talk directly to the canvas element and set and get the canvas data directly.

  0.2 The canvas data is also stored in the Elm model, and all modifications to it are also done to the canvas data stored in the canvas element itself.

  0.3 The first method (0.1) is technically simpler, and more performance. The second method (0.2) would probably be have more intuitive and readable code. The second method also has some inherent safety, as canvas elements are liable to being garbage collected, and when it is, its canvas data will be destroyed.
