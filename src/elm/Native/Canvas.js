var _user$project$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function drawCanvas(domNode, data) {
    return domNode;
  }

  function listToJSArray(list, array) {
    if (list.ctor == "::") {
      array.push(list._0);
      return listToJSArray(list._1, array);
    } 
    return array;
  }

  function canvas(factList, width, height, data) {

    var model = {
      width: width,
      height: height,
      data: listToJSArray(data, [])
    };

    // console.log('A', listToJSArray(data,[]));

    return _elm_lang$virtual_dom$Native_VirtualDom.custom(factList, model, implementation);
  }

  // function toHtml(functionCalls, factList, renderables) {
  // function toHtml(factList, renderables) {
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
    diff: diff
  };

  function renderCanvas(model) {

    LOG('Render canvas');
    var canvas = document.createElement('canvas');

    canvas.width        = model.width;
    canvas.height       = model.height;
    canvas.style.width  = model.width;
    canvas.style.height = model.height

    // console.log(model)

    var ctx = canvas.getContext('2d');
    var imageData = ctx.getImageData(0, 0, model.width, model.height);

    for (var i = 0; i < imageData.data.length; i++) {
      console.log(model.data[i]);
      imageData.data[i] = model.data[i];
    }
    // console.log(imageData);

    ctx.putImageData(imageData, 0, 0);

    // ctx.beginPath();
    // ctx.rect(0, 0, model.width, model.height);
    // ctx.fillStyle = "red";
    // ctx.fill();

    return canvas;
  }


  function diff(oldModel, newModel) {
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
