var _Chadtech$elm_canvas$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function get(id) {
    var canvas = document.getElementById(id);

    if (canvas === null) {
      return _elm_lang$core$Maybe$Nothing;
    } else {
      var ctx = canvas.getContext('2d');

      var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

      return _elm_lang$core$Maybe$Just({
        ctor: "ImageData",
        width: canvas.width,
        height: canvas.height,
        data: _elm_lang$core$Native_Array.fromJSArray(imageData.data)
      })
    }
  }

  function cropGet(id, origin, width, height) {
    var canvas = document.getElementById(id);

    if (canvas === null) {
      return _elm_lang$core$Maybe$Nothing;
    } else {
      var ctx = canvas.getContext('2d');

      var imageData = ctx.getImageData(origin.x, origin.y, width, height);

      return _elm_lang$core$Maybe$Just({
        ctor: "ImageData",
        width: imageData.width,
        height: imageData.height,
        data: _elm_lang$core$Native_Array.fromJSArray(imageData.data)
      });
    }
  }

  function put(imageData, position, id) {

    var canvas = document.getElementById(id);

    if (canvas === null) {
      return _elm_lang$core$Maybe$Nothing;
    } else {
      var ctx = canvas.getContext('2d');

      var data = _elm_lang$core$Native_Array.toJSArray(imageData.data);
      var drawing = ctx.createImageData(imageData.width, imageData.height);

      var i = 0;
      while (i < data.length) {
        drawing.data[i] = data[i];
        i++;
      }

      ctx.putImageData(drawing, position.x, position.y);
      var canvasImageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

      return _elm_lang$core$Maybe$Just({
        ctor: "ImageData",
        width: canvas.width,
        height: canvas.height,
        data: _elm_lang$core$Native_Array.fromJSArray(canvasImageData.data)
      });
    }
  }

  function setPixel(pixel, id) {
    var canvas = document.getElementById(id);

    if (canvas === null) {
      return _elm_lang$core$Maybe$Nothing;
    } else {

      var ctx = canvas.getContext('2d');

      var imageData = ctx.createImageData(1, 1);
      var data = imageData.data;

      data[0] = pixel.color._0;
      data[1] = pixel.color._1;
      data[2] = pixel.color._2;
      data[3] = Math.floor(pixel.color._3 * 255);

      ctx.putImageData(imageData, pixel.position.x, pixel.position.y);

      var canvasImageData = ctx.getImageData(0, 0, canvas.width, canvas.height);

      return _elm_lang$core$Maybe$Just({
        ctor: "ImageData",
        width: canvas.width,
        height: canvas.height,
        data: _elm_lang$core$Native_Array.fromJSArray(canvasImageData.data)
      });
    }
  }


  function canvas(factList, width, height, data) {
    LOG("CANVAS")
    var model = {
      width:  width,
      height: height,
      data: _elm_lang$core$Native_Array.toJSArray(data)
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
    LOG('RENDER CANVAS');
    return drawCanvas(document.createElement('canvas'), model);
  }


  function diff(oldModel, newModel) {
    LOG("DIFF")

    newModel.model.cache = oldModel.model.cache;

    return {
      applyPatch: function(domElement) { return domElement },
      data: oldModel
    };

  }


  return {
    get: get,
    cropGet: F4(cropGet),
    setPixel: F2(setPixel),
    put: F3(put),
    canvas: F4(canvas)
  };
}();
