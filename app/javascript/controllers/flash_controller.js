import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const timeout = this.element.classList.contains("is-success") ? 3000 : 10000;

    setTimeout(() => this.remove(), timeout);
  }

  remove() {
    this.element.remove()
  }
}
