import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.updateLabel()
  }

  toggle() {
    const nextTheme = document.documentElement.dataset.theme === "light" ? "dark" : "light"
    document.documentElement.dataset.theme = nextTheme
    localStorage.setItem("marketplace-theme", nextTheme)
    this.updateLabel()
  }

  updateLabel() {
    const isLight = document.documentElement.dataset.theme === "light"
    this.element.setAttribute("aria-label", isLight ? "Переключить темную тему" : "Переключить светлую тему")
    this.element.setAttribute("title", isLight ? "Переключить темную тему" : "Переключить светлую тему")
  }
}
