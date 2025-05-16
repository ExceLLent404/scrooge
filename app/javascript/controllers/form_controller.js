import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "submit" ]

  submitWithDelay() {
    setTimeout(() => this.submitTarget.click(), 300);
  }
}
