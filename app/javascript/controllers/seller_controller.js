import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "phone"]

  reveal() {
    this.phoneTarget.classList.remove("hidden")
    this.buttonTarget.classList.add("hidden")
  }
}
