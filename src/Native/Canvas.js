var _Chadtech$elm_canvas$Native_Canvas = function () {

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


  function drawImage(image, position, model) {

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


  function fromImageData(array, width, height) {

    var canvas = document.createElement("canvas");

    canvas.width = width;
    canvas.height = height;

    var ctx = canvas.getContext("2d");

    var imageData = ctx.createImageData(width, height);
    var data = imageData.data;

    var dataToPut = _elm_lang$core$Native_Array.toJSArray(array);

    var i = 0;
    while (i < dataToPut) {
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


  function toHtml(factList, canvas) {
    LOG("TO HTML")

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, canvas, implementation);

  }

  function fill(color, model) {
    var canvas = model.canvas;

    var ctx = canvas.getContext('2d');

    var imageData = ctx.createImageData(canvas.width, canvas.height);
    var data = imageData.data;

    var numberOfPixels = canvas.width * canvas.height

    var i = 0;
    while (i < numberOfPixels) {
      var pixelIndex = i * 4
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

    var canvas = model.canvas;
    var ctx = canvas.getContext('2d');

    ctx.drawImage(modelToDraw.canvas, position.x, position.y);

    return model;
  }

  var implementation = {
    render: renderCanvas,
    diff:   diff,
  };

  function renderCanvas(model) {
    LOG('RENDER CANVAS');

    return model.canvas;  
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
    initialize: F2(initialize),
    fill: F2(fill),
    getSize: getSize,
    drawCanvas: F3(drawCanvas),
    loadImage: loadImage,
    drawImage: F3(drawImage),
    setPixel: F3(setPixel),
    toHtml: F2(toHtml),
    getImageData: getImageData,
    fromImageData: F3(fromImageData),
  };
}();
