import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  show() {
    this.previewTarget.src = window.URL.createObjectURL(this.inputTarget.files[0])
  }
}
