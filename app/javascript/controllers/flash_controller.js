import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.timeout = window.setTimeout(() => this.dismiss(), 5000)
  }

  disconnect() {
    window.clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.remove()
  }
}
