import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "name" ]

  changeName() {
    this.nameTarget.textContent = this.inputTarget.files[0].name;
  }
}
