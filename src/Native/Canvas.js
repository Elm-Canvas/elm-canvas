var _elm_community$canvas$Native_Canvas = function () {

  function LOG(msg) {
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
      ctor: 'Canvas',
      canvas: getCanvas,
      width: canvas.width,
      height: canvas.height
    }
  }

  // This is how we ensure immutability
  // Canvas elements are never modified
  // and passed along. They are copied,
  // and the clone is passed along.
  function cloneModel(model) {

    var canvas = document.createElement("canvas");
    canvas.width = model.width;
    canvas.height = model.height;

    var ctx = canvas.getContext('2d')
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

    var ctx = model.canvas().getContext('2d');

    while (drawOps.ctor !== "[]") {
      handleDrawOp(ctx, drawOps._0);

      drawOps = drawOps._1;
    }

    return model;
  }

  function handleDrawOp (ctx, drawOp) {
    switch (drawOp.ctor) {
      case "Font" :
        ctx.font = drawOp._0;
        break;

      case "StrokeText" :
        var position = drawOp._1;

        ctx.strokeText(drawOp._0, position.x, position.y)
        break;

      case "FillText" :
        var position = drawOp._1;

        ctx.fillText(drawOp._0, position.x, position.y)
        break;

      case "GlobalAlpha" :
        ctx.globalAlpha = drawOp._0;
        break;

      case "GlobalCompositionOp" :
        // This converts the type from camel case to dash case.
        var op = drawOp._0.ctor.replace(/([a-z])([A-Z])/g, '$1-$2').toLowerCase();

        ctx.globalCompositeOperation = op;
        break;

      case "LineCap" :
        var cap = drawOp._0.ctor.toLowerCase();

        ctx.lineCap = cap;
        break;

      case "LineWidth" :
        ctx.lineWidth = drawOp._0;
        break;

      case "LineTo" :
        var position = drawOp._0;
        ctx.lineTo(position.x, position.y);
        break;

      case "BeginPath" :
        ctx.beginPath()
        break;

      case "Rect" :
        var position = drawOp._0;
        var size = drawOp._1;

        ctx.rect(position.x, position.y, size.width, size.height);
        break;

      case "FillStyle" :

        var color = _elm_lang$core$Color$toRgb(drawOp._0);

        var cssString = 
          'rgba(' + color.red + 
          ',' + color.green + 
          ',' + color.blue + 
          ',' + color.alpha + 
          ')';

        ctx.fillStyle = cssString;
        break;

      case "Fill" :
        ctx.fill();
        break;
    }
  }


  function loadImage(source) {
    LOG("LOAD IMAGE");

    var Scheduler = _elm_lang$core$Native_Scheduler;
    return Scheduler.nativeBinding(function (callback) {
      var img = new Image();

      img.onload = function () {
        var canvas = document.createElement('canvas');

        canvas.width = img.width;
        canvas.height = img.height;

        var ctx = canvas.getContext('2d');

        ctx.drawImage(img, 0, 0);

        callback(Scheduler.succeed(makeModel(canvas)));
      };

      img.onerror = function () {
        callback(Scheduler.fail({ ctor: 'Error' }));
      };

      img.crossOrigin = "Anonymous";
      img.src = source;
    });
  }


  function getImageData(model) {
    LOG("GET IMAGE DATA");

    var canvas = model.canvas();

    var ctx = canvas.getContext('2d');

    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    return _elm_lang$core$Native_Array.fromJSArray(imageData.data);
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

    return cloneModel(model).canvas();  
  }


  function diff(oldModel, newModel) {
    LOG("DIFF")

    return {
      applyPatch: function(domNode, data) {
        LOG("APPLY PATCH");
        return data.model.canvas();
      },
      data: newModel
    };

  }

  return {
    initialize: initialize,
    setSize: F2(setSize),
    getSize: getSize,
    loadImage: loadImage,
    toHtml: F2(toHtml),
    getImageData: getImageData,
    clone: cloneModel,
    batch: F2(batch)
  };
}();
