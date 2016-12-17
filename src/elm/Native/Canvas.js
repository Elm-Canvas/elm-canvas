var _Chadtech$elm_canvas$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function canvasPatch(domNode, data) {
    return drawCanvas(domNode, data.model);
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
    return data.map(String).reduce(function(memo, item) {
      return memo + item;
    });
  }

  function diff(oldModel, newModel) {

    var oldString = dataToString(oldModel.model.data);
    var newString = dataToString(newModel.model.data);

    var patch;

    if (newString !== oldString) {
      patch = canvasPatch;
    } else {
      patch = function(a) { return a }
    }

    newModel.model.cache = oldModel.model.cache;

    return {
      applyPatch: patch,
      data: newModel
    };
  }

  return {
    canvas: F4(canvas),
  };

}();
