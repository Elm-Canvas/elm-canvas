var _Chadtech$elm_canvas$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function putPixels(canvas, pixels) {
    console.log("CANVAS", canvas, "PIXELS", pixels)
    return canvas;
  }

  function setPixels(canvasId, pixels) {
    LOG("SET PIXELS");
    var Scheduler = _elm_lang$core$Native_Scheduler;

    return Scheduler.nativeBinding(function (callback) {

      var canvas = document.getElementById(canvasId);

      if (canvas === null) {
        callback(Scheduler.fail({
          ctor: 'CanvasDoesNotExist'
        }))
      } else {

        var ctx = canvas.getContext('2d');

        pixels = listToJSArray(pixels).map(formatPixel);

        pixels.forEach(function(pixel) {
          var imageData = ctx.createImageData(1,1);
          var data = imageData.data;

          data[0] = pixel.r;
          data[1] = pixel.g;
          data[2] = pixel.b;
          data[3] = pixel.a;

          ctx.putImageData(imageData, pixel.x, pixel.y)
        })

        callback(Scheduler.succeed({
          ctor: '()'
        }))
      }
    })
  }

  function formatPixel(pixel) {
    return {
      r: pixel.color._0,
      g: pixel.color._1,
      b: pixel.color._2,
      a: Math.floor(pixel.color._3 * 255),
      x: pixel.position.x,
      y: pixel.position.y,
    }
  }


  function listToJSArray(list) {
    var output = [];
    while (list.ctor == "::") {
      output.push(list._0);
      list = list._1;
    }
    return output;
  }


  function canvasPatch(domNode, data) {
    return drawCanvas(domNode, data.model);
  }


  function canvas(factList, width, height, data) {
    var model = {
      width:  width,
      height: height,
      data:   listToJSArray(data)
    };
    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);
  }

  var implementation = {
    render: renderCanvas,
    diff:   diff,
  };


  function drawCanvas(canvas, model) {
    canvas.width        = model.width;
    canvas.height       = model.height;
    canvas.style.width  = model.width;
    canvas.style.height = model.height

    var ctx       = canvas.getContext('2d');
    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    for (var i = 0; i < imageData.data.length; i++) {
      imageData.data[i] = model.data[i];
    }

    ctx.putImageData(imageData, 0, 0);

    return canvas;
  }


  function renderCanvas(model) {
    LOG('Render canvas');
    return drawCanvas(document.createElement('canvas'), model);
  }


  function dataToString(data) {
    if (data.length === 0) { 
      return ""; 
    }

    return data.map(String).reduce(function(memo, item) {
      return memo + item;
    });
  }


  function diff(oldModel, newModel) {

    newModel.model.cache = oldModel.model.cache;

    return {
      applyPatch: function(domElement) { return domElement },
      data: oldModel
    };

    // var oldString = dataToString(oldModel.model.data);
    // var newString = dataToString(newModel.model.data);

    // var patch;

    // if (newString !== oldString) {
    //   patch = canvasPatch;
    // } else {
    //   patch = function(a) { return a }
    // }

    // newModel.model.cache = oldModel.model.cache;

    // return {
    //   applyPatch: patch,
    //   data: newModel
    // };
  }


  return {
    putPixels: F2(putPixels),
    setPixels: F2(setPixels),
    canvas: F4(canvas)
  };
}();
