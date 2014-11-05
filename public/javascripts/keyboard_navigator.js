function KeyboardNavigator () {
  document.addEventListener("keyup", this.keyupHandler.bind(this), false);
}

(function () {
  this.keyupHandler = function (ev){
    ev.preventDefault();
    ev.stopPropagation();

    if (ev.keyCode == "37") {
      var prevLink = document.querySelector('link[rel="prev"]');
      if (prevLink) {
        document.location = prevLink.href;
      }
    }
    else if (ev.keyCode == "39") {
      var nextLink = document.querySelector('link[rel="next"]');
      if (nextLink) {
        document.location = nextLink.href;
      }
    }
    else if (ev.keyCode == "27") {
      var upLink = document.querySelector('link[rel="up"]');
      if (upLink) {
        document.location = upLink.href;
      }
    }
  }
}).apply(KeyboardNavigator.prototype);

var keyboardNavigator = new KeyboardNavigator();