import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.submitTimer = null
  }

  disconnect() {
    clearTimeout(this.submitTimer)
  }

  submit() {
    this.element.requestSubmit()
  }

  priceChanged() {
    clearTimeout(this.submitTimer)
    this.submitTimer = setTimeout(() => this.submit(), 500)
  }
}
