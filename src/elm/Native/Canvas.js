var _user$project$Native_Canvas = function () {

  function LOG(msg) {
    // console.log(msg);
  }

  function drawCanvas(domNode, data) {
    return domNode;
  }

  // function toHtml(functionCalls, factList, renderables) {
  // function toHtml(factList, renderables) {
    function toHtml(factList) {


    var model = {
      // functionCalls: functionCalls,
      cache: {}
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

    var ctx = canvas.getContext('2d');

    ctx.beginPath();
    ctx.rect(20, 20, 150, 100);
    ctx.fillStyle = "red";
    ctx.fill();

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
    // toHtml: F3(toHtml),
    // toHtml: F2(toHtml)
    toHtml: toHtml
  };

}();
