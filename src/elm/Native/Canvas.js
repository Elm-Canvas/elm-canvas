var _user$project$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function drawCanvas(domNode, data) {
    return drawCanvasData(domNode, data.model);
  }

  function listToJSArray(list) {
    var output = [];

    while (list.ctor == "::") {
      output.push(list._0);
      list = list._1;
    }

    return output;
  }

  function canvas(factList, width, height, data) {

    var model = {
      width: width,
      height: height,
      data: listToJSArray(data)
    };

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);
  }

  function toHtml(factList, width, height) {

    var data = [];
    while (data.length < (width * height * 4)) {
      data.push(255 * Math.random());
    }

    var model = {
      width: width,
      height: height,
      data: data
    };

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);
  }

  var implementation = {
    render: renderCanvas,
    diff: diff,
  };

  function drawCanvasData(canvas, model) {
    // canvas = document.createElement('canvas');

    canvas.width        = model.width;
    canvas.height       = model.height;
    canvas.style.width  = model.width;
    canvas.style.height = model.height

    var ctx = canvas.getContext('2d');
    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    for (var i = 0; i < imageData.data.length; i++) {
      imageData.data[i] = model.data[i];
    }

    ctx.putImageData(imageData, 0, 0);

    return canvas;
  }

  function renderCanvas(model) {

    LOG('Render canvas');

    return drawCanvasData(document.createElement('canvas'), model);
  }


  function diff(oldModel, newModel) {

    var oldString = oldModel.model.data
      .map(function(datum) { return String(datum); })
      .reduce(function(memo, item) {
        return memo + item;
      })

    var newString = newModel.model.data
      .map(function(datum) { return String(datum); })
      .reduce(function(memo, item) {
        return memo + item;
      })

    var whatToDo;

    if (newString === oldString) {
      whatToDo = drawCanvas
    } else {
      whatToDo = function(a) { return a }
    }

    newModel.model.cache = oldModel.model.cache;
    return {
      applyPatch: drawCanvas,
      data: newModel
    };
  }

  return {
    canvas: F4(canvas),
    toHtml: F3(toHtml),
    // toHtml: F2(toHtml)
    // toHtml: toHtml
  };

}();
