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
        var point = drawOp._1;

        ctx.strokeText(drawOp._0, point.x, point.y)
        break;

      case "FillText" :
        var point = drawOp._1;

        ctx.fillText(drawOp._0, point.x, point.y)
        break;

      case "TextAlign" :
        ctx.textAlign = drawOp._0;
        break;

      case "TextBaseline" :
        ctx.textBaseline = drawOp._0;
        break;

      case "GlobalAlpha" :
        ctx.globalAlpha = drawOp._0;
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

      case "LineDashOffset" :
        ctx.lineDashOffset = drawOp._0;
        break;

      case "LineWidth" :
        ctx.lineWidth = drawOp._0;
        break;

      case "LineTo" :
        var point = drawOp._0;

        ctx.lineTo(point.x, point.y);
        break;

      case "BezierCurveTo" :
        var p0 = drawOp._0;
        var p1 = drawOp._1;
        var p2 = drawOp._2;

        ctx.bezierCurveTo(p0.x, p0.y, p1.x, p1.y, p2.x, p2.y);
        break;

      case "QuadraticCurveTo" :
        var p0 = drawOp._0;
        var p1 = drawOp._1;

        ctx.quadraticCurveTo(p0.x, p0.y, p1.x, p1.y);
        break;

      case "MoveTo" :
        var point = drawOp._0;
        
        ctx.moveTo(point.x, point.y);
        break;

      case "ShadowBlur" :
        ctx.shadowBlur = drawOp._0;
        break;

      case "ShadowColor" :
        ctx.shadowColor = toCssString(drawOp);
        break;

      case "ShadowOffsetX" :
        ctx.shadowOffsetX = drawOp._0;
        break;

      case "ShadowOffsetY" :
        ctx.shadowOffsetY = drawOp._0;
        break;

      case "Arc" :
        var point = drawOp._0;
        ctx.arc(point.x, point.y, drawOp._1, drawOp._2, drawOp._3);
        break;

      case "ArcTo" :
        var point0 = drawOp._0;
        var point1 = drawOp._1;
        ctx.arcTo(point0.x, point0.y, point1.x, point1.y, drawOp._2);
        break;

      case "Stroke" :
        ctx.stroke();
        break;

      case "BeginPath" :
        ctx.beginPath()
        break;

      case "Rect" :
        var point = drawOp._0;
        var size = drawOp._1;

        ctx.rect(point.x, point.y, size.width, size.height);
        break;

      case "Rotate" :
        ctx.rotate(drawOp._0);
        break;

      case "Scale" :
        ctx.scale(drawOp._0, drawOp._1);
        break;

      case "Translate" :
        var point = drawOp._0;

        ctx.translate(point.x, point.y);
        break;

      case "Transform" :
        var a = drawOp._0;
        var b = drawOp._1;
        var c = drawOp._2;
        var d = drawOp._3;
        var e = drawOp._4;
        var f = drawOp._5;

        ctx.transform(a, b, c, d, e, f);
        break;

      case "SetLineDash" :
        var lineDash = [];
        var lineDashAsList = drawOp._0;

        while (lineDashAsList.ctor === "::") {
          lineDash.push(lineDashAsList._0);
          lineDashAsList = lineDashAsList._1;
        }

        ctx.setLineDash(lineDash);
        break;

      case "ClearRect" :
        var point = drawOp._0;
        var size = drawOp._1;

        ctx.clearRect(point.x, point.y, size.width, size.height);
        break;

      case "Clip" :
        ctx.clip();
        break;

      case "ClosePath" :
        ctx.closePath();
        break;

      case "StrokeRect" :
        var point = drawOp._0;
        var size = drawOp._1;

        ctx.strokeRect(point.x, point.y, size.width, size.height);
        break;

      case "StrokeStyle" :
        ctx.strokeStyle = toCssString(drawOp);
        break;

      case "FillStyle" :
        ctx.fillStyle = toCssString(drawOp);
        break;

      case "Fill" :
        ctx.fill();
        break;

      case "FillRect":
        var point = drawOp._0;
        var size = drawOp._1;

        ctx.fillRect(point.x, point.y, size.width, size.height);
        break;

      case "PutImageData" :
        var point = drawOp._2;
        var size = drawOp._1;
        var data = _elm_lang$core$Native_Array.toJSArray(drawOp._0);

        var imageData = ctx.createImageData(size.width, size.height);

        for (var index = 0; index < data.length; index++) {
          imageData.data[ index ] = data[ index ];
        }

        ctx.putImageData(imageData, point.x, point.y);
        break;

      case "Draw" :
        var point = drawOp._1;
        var canvas = drawOp._0.canvas();

        ctx.drawImage(canvas, point.x, point.y);
        break;
    }
  }

  function toCssString(drawOp) {        
    var color = _elm_lang$core$Color$toRgb(drawOp._0);
    return 'rgba(' + [ color.red, color.green, color.blue, color.alpha ].join(',') + ')'
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

      if (source.slice(0,5) !== "data:") {
        img.crossOrigin = "Anonymous";
      }
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
