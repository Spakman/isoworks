function DeleteForm () {
  this.form = document.getElementById("delete");
  if (this.form) {
    this.fakeDeleteButton = document.getElementById("fakeDelete");
    this.cancelButton = document.getElementById("cancelDelete");

    this.fakeDeleteButton.addEventListener("click", this.fakeClickHandler.bind(this), false);
    this.cancelButton.addEventListener("click", this.cancelClickHandler.bind(this), false);
  }
}

(function () {
  this.fakeClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    this.hide(this.fakeDeleteButton);
    this.show(this.form);
  };

  this.cancelClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    this.hide(this.form);
    this.show(this.fakeDeleteButton);
  };

  this.show = function (element) {
    element.style.display = "block";
  };

  this.hide = function (element) {
    element.style.display = "none";
  };
}).apply(DeleteForm.prototype);

window.onload = function () {
  var deleteForm = new DeleteForm();
}
