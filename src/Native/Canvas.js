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


  function loadImage(source) {
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
    getSize: getSize,
    loadImage: loadImage,
    toHtml: F2(toHtml),
    getImageData: getImageData,
  };
}();
