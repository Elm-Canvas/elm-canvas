var _elm_community$canvas$Native_Canvas = function () {  // eslint-disable-line no-unused-vars


  function LOG(msg) { // eslint-disable-line no-unused-vars
    // console.log(msg);
  }


  function makeModel(canvas) {

    // The elm debugger crashes when it tries to
    // traverse an html object. So instead
    // of passing along a canvas element, we
    // pass along a function that returns it
    function getCanvas() {
      return canvas;
    }

    return {
      ctor: "Canvas",
      canvas: getCanvas,
      width: canvas.width,
      height: canvas.height
    };
  }

  // This is how we ensure immutability.
  // Canvas elements are never modified
  // and passed along. They are copied,
  // and the clone is passed along.
  function cloneModel(model) {

    var canvas = document.createElement("canvas");
    canvas.width = model.width;
    canvas.height = model.height;

    var ctx = canvas.getContext("2d");
    ctx.drawImage(model.canvas(), 0, 0);

    return makeModel(canvas);

  }


  function initialize(size) {

    var canvas = document.createElement("canvas");
    canvas.width = size.width;
    canvas.height = size.height;

    return makeModel(canvas);

  }


  function batch(drawOps, model) {
    model = cloneModel(model);

    var ctx = model.canvas().getContext("2d");

    while (drawOps.ctor !== "[]") {
      handleDrawOp(ctx, drawOps._0);

      drawOps = drawOps._1;
    }

    return model;
  }


  function handleDrawOp (ctx, drawOp) {
    var position, size, color;

    switch (drawOp.ctor) {
    case "Font" :

      ctx.font = drawOp._0;
      break;

    case "StrokeText" :

      position = drawOp._1;

      ctx.strokeText(drawOp._0, position.x, position.y);
      break;

    case "FillText" :

      position = drawOp._1;

      ctx.fillText(drawOp._0, position.x, position.y);
      break;

    case "GlobalCompositionOp" :

      ctx.globalCompositeOperation = drawOp._0;
      break;

    case "LineCap" :

      ctx.lineCap = drawOp._0;
      break;

    case "LineJoin" :
    
      ctx.lineJoin = drawOp._0;
      break;

    case "GlobalAlpha" :

      ctx.globalAlpha = drawOp._0;
      break;

    case "LineDashOffset" :
    
      ctx.lineDashOffset = drawOp._0;
      break;

    case "LineWidth" :

      ctx.lineWidth = drawOp._0;
      break;

    case "LineTo" :

      position = drawOp._0;

      ctx.lineTo(position.x, position.y);
      break;

    case "MoveTo" :

      position = drawOp._0;

      ctx.moveTo(position.x, position.y);
      break;

    case "Stroke" :

      ctx.stroke();
      break;

    case "BeginPath" :

      ctx.beginPath();
      break;

    case "Rect" :

      position = drawOp._0;
      size = drawOp._1;

      ctx.rect(position.x, position.y, size.width, size.height);
      break;

    case "StrokeRect" :

      position = drawOp._0;
      size = drawOp._1;

      ctx.strokeRect(position.x, position.y, size.width, size.height);
      break;

    case "StrokeStyle" :

      color = _elm_lang$core$Color$toRgb(drawOp._0); // eslint-disable-line no-undef

      ctx.strokeStyle = getCssString(color);
      break;


    case "FillStyle" :

      color = _elm_lang$core$Color$toRgb(drawOp._0); // eslint-disable-line no-undef

      ctx.fillStyle = getCssString(color);
      break;

    case "Fill" :

      ctx.fill();
      break;

    case "PutImageData" :

      position = drawOp._2;
      size = drawOp._1;
      var data = _elm_lang$core$Native_Array.toJSArray(drawOp._0); // eslint-disable-line no-undef

      var imageData = ctx.createImageData(size.width, size.height);

      for (var index = 0; index < data.length; index++) {
        imageData.data[ index ] = data[ index ];
      }

      ctx.putImageData(imageData, position.x, position.y);
      break;

    case "ClearRect" :

      position = drawOp._0;
      size = drawOp._1;

      ctx.clearRect(position.x, position.y, size.width, size.height);
      break;

    case "DrawImage":

      var srcCanvas = drawOp._0.canvas();
      var drawImageOp = drawOp._1;
      var srcPosition, srcSize, destPosition, destSize;

      switch (drawOp._1.ctor) {
      case "At":

        destPosition = drawImageOp._0;
        ctx.drawImage(
          srcCanvas,
          destPosition.x,
          destPosition.y
        );
        break;

      case "Scaled":

        destPosition = drawImageOp._0;
        destSize = drawImageOp._1;
        ctx.drawImage(
          srcCanvas,
          destPosition.x, destPosition.y,
          destSize.width, destSize.height
        );
        break;

      case "CropScaled":

        srcPosition = drawImageOp._0;
        srcSize = drawImageOp._1;
        destPosition = drawImageOp._2;
        destSize = drawImageOp._3;

        ctx.drawImage(
          srcCanvas,
          srcPosition.x, srcPosition.y,
          srcSize.width, srcSize.height,
          destPosition.x, destPosition.y,
          destSize.width, destSize.height
        );
        break;
      }

      break;
    }
  }


  function toDataURL (mimetype, quality, model) {
    return model.canvas().toDataURL(mimetype, quality);
  }


  function getCssString (color) {
    return "rgba(" + [ color.red, color.green, color.blue, color.alpha ].join(",") + ")";
  }


  function loadImage(source) {
    LOG("LOAD IMAGE");

    var Scheduler = _elm_lang$core$Native_Scheduler; // eslint-disable-line no-undef
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();

      img.onload = function () {
        var canvas = document.createElement("canvas");

        canvas.width = img.width;
        canvas.height = img.height;

        var ctx = canvas.getContext("2d");

        ctx.drawImage(img, 0, 0);

        callback(Scheduler.succeed(makeModel(canvas)));
      };

      img.onerror = function () {
        callback(Scheduler.fail({ ctor: "Error" }));
      };

      if (source.slice(0,5) !== "data:") {
        img.crossOrigin = "Anonymous";
      }
      img.src = source;
    });
  }


  function getImageData(model) {
    LOG("GET IMAGE DATA");

    var canvas = model.canvas();
    var ctx = canvas.getContext("2d");
    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    return _elm_lang$core$Native_Array.fromJSArray(imageData.data); // eslint-disable-line no-undef
  }


  function setSize(size, model) {
    model = cloneModel(model);
    model.width = size.width;
    model.height = size.height;

    return model;
  }


  function getSize(model) {
    return {
      width: model.width,
      height: model.height
    };
  }



  function toHtml(factList, model) {
    LOG("TO HTML");

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation); // eslint-disable-line no-undef

  }


  var implementation = {
    render: renderCanvas,
    diff: diff
  };


  function renderCanvas(model) {
    LOG("RENDER CANVAS");
    return cloneModel(model).canvas();
  }


  function diff(old, new_) {
    LOG("DIFF");


    var diffCanvases = old.model.canvas() !== new_.model.canvas();

    return {
      applyPatch: function(domNode, data) {
        LOG("APPLY PATCH");

        if (diffCanvases) {

          var model = data.model;

          domNode.width = model.width;
          domNode.height = model.height;

          var ctx = domNode.getContext("2d");
          ctx.clearRect(0, 0, domNode.width, domNode.height);
          ctx.drawImage(data.model.canvas(), 0, 0);
        }

        return domNode;

      },
      data: new_
    };

  }


  return {
    initialize: initialize,
    setSize: F2(setSize), // eslint-disable-line no-undef
    getSize: getSize,
    loadImage: loadImage,
    toHtml: F2(toHtml), // eslint-disable-line no-undef
    getImageData: getImageData,
    clone: cloneModel,
    batch: F2(batch), // eslint-disable-line no-undef
    toDataURL: F3(toDataURL) // eslint-disable-line no-undef
  };
}();
