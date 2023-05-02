import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'target', 'subject' ];
  /**
   * @tag elem - Element requests the controller
   *    (ie. <input data-controller='validation'>)
   * @tag parent - Parent requests the controller
   *    (ie. <div data-controller='vaidation><input></div>)
   */

  /**
   * @tag elem
   */
  isTextInputValid() {
    if (this.element.value.length > 0) {
      if (!this.element.checkValidity()) {
        this.element.classList.add('is-invalid');
        return;
      }
    }
    this.element.classList.remove('is-invalid');
  }

  /**
   * @tag elem
   */
  isTextAddressValid() {}

  /**
   * @tag parent
   */
  isTextMatching() {
    if (this.subjectTarget.value.length != 0 && this.targetTarget.value.length != 0) {
      if (this.subjectTarget.value != this.targetTarget.value) {
          this.subjectTarget.classList.add('is-invalid');
          this.targetTarget.classList.add('is-invalid');
          return;
      }
    }
    this.subjectTarget.classList.remove('is-invalid');
    this.targetTarget.classList.remove('is-invalid');
  }
}
