function SearchForm (params) {
  this.form = document.getElementById(params.formId);
  this.form.addEventListener("submit", this.submitHandler.bind(this), false);
  this.searchTermsInput = document.getElementById(params.searchTerms);
}

(function () {
  this.submitHandler = function (ev) {
    ev.preventDefault();
    ev.stopPropagation();
    window.location = this.form.action + "/" + this.searchTermsInput.value;
  }
}).apply(SearchForm.prototype);
