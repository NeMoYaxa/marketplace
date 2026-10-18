import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.close = this.close.bind(this)
    document.addEventListener("click", this.close)
    document.addEventListener("keydown", this.closeOnEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  close(event) {
    if (event && this.element.contains(event.target)) return
    if (this.hasMenuTarget) this.menuTarget.classList.add("hidden")
  }

  closeOnEscape = (event) => {
    if (event.key === "Escape") this.close()
  }
}
