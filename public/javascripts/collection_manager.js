function CollectionManager () {
  this.addCollectionForm = document.getElementById("addCollection");
  this.showCollectionForm = document.getElementById("showAddCollection");
  this.addCollectionSubmit = document.getElementById("addCollectionSubmit");
  if (!this.addCollectionForm) {
    return;
  }
  this.addCollectionForm.addEventListener("submit", this.addCollectionClickHandler.bind(this), false);
  this.addCollectionSubmit.addEventListener("click", this.addCollectionClickHandler.bind(this), false);

  var collections = document.getElementById("collections");
  if (collections) {
    collections = collections.children;
    for (index = 0; index < collections.length; index++) {
      this.addDeleteFormsToListItem(collections[index]);
    }
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

  this.addCollectionClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var collection = document.getElementById("collection")
    if (collection.value == "") {
      return false;
    }
    var params = "collection=" + encodeURIComponent(collection.value);

    this.ajaxPost(this.addCollectionForm.action, params, function () {
      this.addCollectionListItem(collection.value);
      this.addCollectionForm.style.display = "none";
      this.showCollectionForm.style.display = "block";
      collection.value = "";
    }.bind(this));
  }

  this.deleteCollectionClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();

    var li = ev.currentTarget.parentNode
    var collection = li.children[0].innerHTML
    var params = "collection=" + encodeURIComponent(collection);
    var addCollectionForm = document.getElementById("addCollection");
    var target = addCollectionForm.action.replace("add_collection", "delete_collection");

    this.ajaxPost(target, params, function () {
      this.removeCollection(li);
      document.getElementById("tag").focus();
    }.bind(this));
  }

  this.removeCollection = function (li) {
    var ul = document.getElementById("collections");
    ul.removeChild(li);
  }

  this.addDeleteFormsToListItem = function (li) {
    var input = document.createElement("input");
    input.type = "image";
    input.src = "/images/delete.png";
    input.className = "delete";
    input.addEventListener("click", this.deleteCollectionClickHandler.bind(this), false);
    li.appendChild(input);
  }

  this.addCollectionListItem = function (collection) {
    var ul = document.getElementById("collections");
    if (!ul) {
      var ul = document.createElement('ul');
      ul.id = "collections";
      var collectionsDiv = document.getElementsByClassName("collections")[0]
      var none = collectionsDiv.lastChild;
      collectionsDiv.replaceChild(ul, none);
    }
    var a = document.createElement('a');
    var li = document.createElement('li');
    a.href = "/collections/" + encodeURIComponent(collection);
    a.appendChild(document.createTextNode(collection));
    li.appendChild(a);
    ul.appendChild(li);
    this.addDeleteFormsToListItem(li);
  }
}).apply(CollectionManager.prototype);
