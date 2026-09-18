import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button"]

  toggle() {
    const isVisible = this.inputTarget.type === "text"

    this.inputTarget.type = isVisible ? "password" : "text"
    this.buttonTarget.classList.toggle("is-visible", !isVisible)
    this.buttonTarget.setAttribute("aria-label", isVisible ? "Показать пароль" : "Скрыть пароль")
    this.buttonTarget.setAttribute("title", isVisible ? "Показать пароль" : "Скрыть пароль")
  }
}
