var _elm_community$canvas$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function initialize(width, height) {
    var canvas = document.createElement("canvas");

    canvas.width = width;
    canvas.height = height;

    return {
      ctor: 'Canvas',
      canvas: canvas,
      width: width,
      height: height,
    }
  }


  function loadImage(source) {
    var Scheduler = _elm_lang$core$Native_Scheduler;
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();

      function getImage() {
        return img;
      }

      img.onload = function () {
        callback(Scheduler.succeed({
          ctor: 'Image',
          img: getImage,
          width: img.width,
          height: img.height
        }));
      };

      img.onerror = function () {
        callback(Scheduler.fail({ ctor: 'Error' }));
      };

      img.crossOrigin = "Anonymous";
      img.src = source;
    });
  }


  function copyCanvas(model) {
    var canvas = document.createElement("canvas");
    canvas.width = model.canvas.width;
    canvas.height = model.canvas.height;

    var ctx = canvas.getContext('2d')
    ctx = ctx.drawImage(model.canvas, 0, 0);

    return {
      ctor: 'Canvas',
      canvas: canvas,
      width: model.canvas.width,
      height: model.canvas.height
    };
  }


  function drawImage(image, position, model) {

    var model = copyCanvas(model);

    var canvas = model.canvas;

    var ctx = canvas.getContext('2d');

    ctx.drawImage(image.img(), position.x, position.y);

    var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

    return model;

  }


  function getImageData(model) {

    var canvas = model.canvas;

    var ctx = canvas.getContext('2d');

    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    return _elm_lang$core$Native_Array.fromJSArray(imageData.data);
  }


  function fromImageData(width, height, array) {
    LOG("FROM IMAGE DATA")

    var canvas = document.createElement("canvas");

    canvas.width = width;
    canvas.height = height;

    var ctx = canvas.getContext("2d");

    var imageData = ctx.createImageData(width, height);
    var data = imageData.data;

    var dataToPut = _elm_lang$core$Native_Array.toJSArray(array);

    var i = 0;
    while (i < dataToPut.length) {
      data[i] = dataToPut[i];
      i++;
    }

    ctx.putImageData(imageData, 0, 0);

    return {
      ctor: 'Canvas',
      canvas: canvas,
      width: width,
      height: height,
    }
  }


  function setPixel(color, position, model) {

    var model = copyCanvas(model);

    var canvas = model.canvas;

    var ctx = canvas.getContext('2d');

    var imageData = ctx.createImageData(1, 1);
    var data = imageData.data;

    data[0] = color._0;
    data[1] = color._1;
    data[2] = color._2;
    data[3] = Math.floor(color._3 * 255);

    ctx.putImageData(imageData, position.x, position.y);

    return model;
  }


  function setPixels(pixels, model) {
    LOG("SET PIXELS")

    var model = copyCanvas(model);

    var canvas = model.canvas;

    var ctx = canvas.getContext('2d');

    while (pixels.ctor == "::") {
      var color = pixels._0._0;
      var position = pixels._0._1;
      var imageData = ctx.createImageData(1,1);
      var data = imageData.data;

      data[0] = color._0;
      data[1] = color._1;
      data[2] = color._2;
      data[3] = Math.floor(color._3 * 255);

      ctx.putImageData(imageData, position.x, position.y);

      pixels = pixels._1;
    }

    return model;

  }


  function calculateIndex(width, x, y) {
    return ((x + (y * width)) * 4);
  }


  function crop(position, width, height, model) {

    var canvas = document.createElement("canvas");
    canvas.width = width;
    canvas.height = height;

    var ctx = canvas.getContext("2d");

    ctx.drawImage(
      model.canvas, 
      position.x, 
      position.y,
      width,
      height,
      0,
      0,
      width,
      height
    );

    return {
      ctor: 'Canvas',
      width: width,
      height: height,
      canvas: canvas
    };
  }


  function fill(color, model) {

    var canvas = document.createElement("canvas");
    canvas.width = model.width;
    canvas.height = model.height;

    var model = {
      ctor: 'Canvas',
      canvas: canvas,
      width: model.width,
      height: model.height
    };

    var ctx = canvas.getContext('2d');

    var imageData = ctx.createImageData(canvas.width, canvas.height);
    var data = imageData.data;

    var numberOfPixels = canvas.width * canvas.height;

    var i = 0;
    while (i < numberOfPixels) {
      var pixelIndex = i * 4;
      data[ pixelIndex     ] = color._0;
      data[ pixelIndex + 1 ] = color._1;
      data[ pixelIndex + 2 ] = color._2;
      data[ pixelIndex + 3 ] = Math.floor(color._3 * 255);
      i++;
    }

    ctx.putImageData(imageData, 0, 0);

    return model;

  }


  function getSize(model) {
    return _elm_lang$core$Native_Utils.Tuple2(model.width, model.height);
  }


  function drawCanvas(modelToDraw, position, model) {
    LOG("DRAW CANVAS")

    var canvas = model.canvas;
    var ctx = canvas.getContext('2d');

    ctx.drawImage(modelToDraw.canvas, position.x, position.y);

    return model;
  }


  function toHtml(factList, canvas) {
    LOG("TO HTML")

    // this is some trickery..

    // by defining implementation in this scope, I am making
    // a new object. The Elm virtual dom checks to see if
    // implementation has changed between re-renders. If it
    // is different, the virtual dom chooses to redraw
    // the element entirely using renderCanvas. This isnt
    // a problem in elm-canvas, because its just handing off
    // an already existing html element stored in the model.
    // In other contexts, or if does for every dom element,
    // this would be greatly un-performant.

    // A more normal way of doing this, would be to define
    // implementation outside of toHtml, on the same level as
    // toHtml and every other function. That way its literally
    // the same object being passed into virtualDom.custom, rather
    // than new - however identical - objects.
    var implementation = 
      {
        render: renderCanvas,
        diff: diff
      }

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, canvas, implementation);

  }

  function renderCanvas(model) {
    LOG('RENDER CANVAS');

    return copyCanvas(model).canvas;  
  }


  function diff(oldModel, newModel) {
    LOG("DIFF")

    return {
      applyPatch: function(domNode, data) {
        LOG("APPLY PATCH");
        return data.model.canvas;
      },
      data: newModel
    };

  }

  return {
    initialize: F2(initialize),
    fill: F2(fill),
    getSize: getSize,
    drawCanvas: F3(drawCanvas),
    loadImage: loadImage,
    drawImage: F3(drawImage),
    crop: F4(crop),
    setPixel: F3(setPixel),
    setPixels: F2(setPixels),
    toHtml: F2(toHtml),
    getImageData: getImageData,
    fromImageData: F3(fromImageData),
  };
}();
