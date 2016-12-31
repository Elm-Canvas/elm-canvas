var _Chadtech$elm_canvas$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function putImageData(imageData, position, canvas) {

    var el = document.getElementById(canvas.id)  

    if (el === null) {

      return canvas;
    
    } else {

      var ctx        = el.getContext('2d');
      var data       = _elm_lang$core$Native_Array.toJSArray(imageData.data);
      var imageData_ = ctx.createImageData(imageData.width, imageData.height);
      var data_      = imageData_.data;

      var i = 0;
      while (i < data.length) {
        data_[i] = data[i];
        i++;
      }

      ctx.putImageData(imageData_, position.x, position.y);
      canvas.imageData.data = _elm_lang$core$Native_Array.fromJSArray(data_);

    }

    return canvas;

  }

  function putPixels(newData, canvas) {
    LOG("PUT PIXELS");

    var el = document.getElementById(canvas.id)  

    if (el === null) {
      return canvas;
    } else {

      var ctx = el.getContext('2d');

      while (newData.ctor == "::") {
        var pixel = formatPixel(newData._0);

        var imageData = ctx.createImageData(1, 1);
        var data = imageData.data;

        data[0] = pixel.r;
        data[1] = pixel.g;
        data[2] = pixel.b;
        data[3] = pixel.a;

        ctx.putImageData(imageData, pixel.x, pixel.y);

        newData = newData._1;
      }
    }

    return canvas;
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
    putPixels: F2(putPixels),
    putImageData: F3(putImageData),
    canvas: F4(canvas)
  };
}();
