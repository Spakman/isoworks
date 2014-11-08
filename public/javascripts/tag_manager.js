function TagManager () {
  this.addTagForm = document.getElementById("addTag");
  if (!this.addTagForm) {
    return;
  }
  this.addTagForm.addEventListener("submit", this.addTagSubmitHandler.bind(this), false);

  var tags = document.getElementById("tags").children;
  for (index = 0; index < tags.length; index++) {
    this.addDeleteFormsToListItem(tags[index]);
  }
}

(function () {
  this.ajaxPost = function (uri, params, callback) {
    var ajax = new XMLHttpRequest();

    ajax.onreadystatechange = function () {
      if (ajax.readyState == 4 && ajax.status == 200) {
        callback();
      }
    }.bind(this);

    ajax.open("POST", uri, true);
    ajax.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    ajax.send(params);
  }

  this.addTagSubmitHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var tag = document.getElementById("tag")
    if (tag.value == "") {
      return false;
    }
    var params = "tag=" + encodeURIComponent(tag.value);

    this.ajaxPost(this.addTagForm.action, params, function () {
      this.addTagListItem(tag.value);
      tag.value = "";
    }.bind(this));
  }

  this.deleteTagClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var li = ev.currentTarget.parentNode
    var tag = li.children[0].innerHTML
    var params = "tag=" + encodeURIComponent(tag);
    var addTagForm = document.getElementById("addTag");
    var target = addTagForm.action.replace("add_tag", "delete_tag");

    this.ajaxPost(target, params, function () {
      this.removeTag(li);
      document.getElementById("tag").focus();
    }.bind(this));
  }

  this.removeTag = function (li) {
    var ul = document.getElementById("tags");
    ul.removeChild(li);
  }

  this.addDeleteFormsToListItem = function (li) {
    var a = document.createElement('a');
    a.href = "";
    a.className = "delete";
    a.appendChild(document.createTextNode("!"));
    a.addEventListener("click", this.deleteTagClickHandler.bind(this), false);
    li.appendChild(a);
  }

  this.addTagListItem = function (tag) {
    var ul = document.getElementById("tags");
    var a = document.createElement('a');
    var li = document.createElement('li');
    a.href = "/tags/" + encodeURIComponent(tag);
    a.appendChild(document.createTextNode(tag));
    li.appendChild(a);
    ul.appendChild(li);
    this.addDeleteFormsToListItem(li);
  }
}).apply(TagManager.prototype);

window.onload = function () {
  var tagManager = new TagManager();
}
