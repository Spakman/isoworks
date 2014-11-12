function HiddenForm (params) {
  this.form = document.getElementById(params.formId);
  if (this.form) {
    this.formShowButton = document.getElementById(params.showButtonId);
    this.cancelButton = document.getElementById(params.cancelButtonId);

    this.formShowButton.addEventListener("click", this.showButtonClickHandler.bind(this), false);
    this.cancelButton.addEventListener("click", this.cancelClickHandler.bind(this), false);
  }
  if (params.textFieldId) {
    this.textField = document.getElementById(params.textFieldId);
  }
  if (params.hide) {
    this.elementToHide = document.getElementById(params.hide);
  }
}

(function () {
  this.showButtonClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    this.hide(this.formShowButton);
    this.show(this.form);
    if (this.textField) {
      this.textField.focus();
    }
    if (this.elementToHide) {
      this.hide(this.elementToHide);
    }
  };

  this.cancelClickHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    this.hide(this.form);
    this.show(this.formShowButton);
    if (this.elementToHide) {
      this.show(this.elementToHide);
    }
  };

  this.show = function (element) {
    element.style.display = "block";
  };

  this.hide = function (element) {
    element.style.display = "none";
  };
}).apply(HiddenForm.prototype);
