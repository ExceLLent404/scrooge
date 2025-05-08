import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  validate({ params: { predicate, value } }) {
    let input = this.element

    if (predicate == "gt" && input.value <= value) {
      input.setCustomValidity(`Value must be greater than ${value}.`)
    } else {
      input.setCustomValidity("")
    }
  }
}
