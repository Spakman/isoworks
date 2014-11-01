function TagManager () {
  this.addTagForm = document.getElementById("addTag");
  this.addTagForm.addEventListener("submit", this.addTagSubmitHandler.bind(this), false);
}

(function () {
  this.addTagSubmitHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var tag = document.getElementById("tag")
    if (tag.value == "") {
      return false;
    }
    var params = "tag=" + encodeURIComponent(tag.value);
    var ajax = new XMLHttpRequest();

    ajax.onreadystatechange = function () {
      if (ajax.readyState == 4 && ajax.status == 200) {
        this.addTagListItem(tag.value);
        tag.value = "";
      }
    }.bind(this);

    ajax.open("POST", this.addTagForm.action, true);
    ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    ajax.send(params);
  }

  this.addTagListItem = function (tag) {
    var ul = document.getElementById("tags");
    var a = document.createElement('a');
    var li = document.createElement('li');
    a.href = "/tags/" + encodeURIComponent(tag);
    a.appendChild(document.createTextNode(tag));
    li.appendChild(a);
    ul.appendChild(li);
  }
}).apply(TagManager.prototype);

window.onload = function () {
  var tagManager = new TagManager();
}
