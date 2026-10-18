import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.close = this.close.bind(this)
    this.positionMenu = this.positionMenu.bind(this)
    this.closeOtherDropdowns = this.closeOtherDropdowns.bind(this)
    document.addEventListener("click", this.close)
    document.addEventListener("keydown", this.closeOnEscape)
    document.addEventListener("dropdown:open", this.closeOtherDropdowns)
    window.addEventListener("scroll", this.close, true)
    window.addEventListener("resize", this.close)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
    document.removeEventListener("keydown", this.closeOnEscape)
    document.removeEventListener("dropdown:open", this.closeOtherDropdowns)
    window.removeEventListener("scroll", this.close, true)
    window.removeEventListener("resize", this.close)
  }

  toggle(event) {
    event.stopPropagation()
    if (this.menuTarget.classList.contains("hidden")) {
      document.dispatchEvent(new CustomEvent("dropdown:open", { detail: this.element }))
      this.menuTarget.classList.remove("hidden")
      this.positionMenu()
    } else {
      this.close()
    }
  }

  select() {
    this.close()
  }

  closeOtherDropdowns(event) {
    if (event.detail !== this.element) this.close()
  }

  positionMenu() {
    if (!this.hasMenuTarget || this.menuTarget.classList.contains("hidden")) return

    const buttonRect = this.element.querySelector("button").getBoundingClientRect()
    const menuRect = this.menuTarget.getBoundingClientRect()
    const gap = 8
    const viewportPadding = 8
    const fitsBelow = buttonRect.bottom + gap + menuRect.height <= window.innerHeight - viewportPadding
    const top = fitsBelow
      ? buttonRect.bottom + gap
      : Math.max(viewportPadding, buttonRect.top - menuRect.height - gap)
    const left = buttonRect.left + menuRect.width <= window.innerWidth - viewportPadding
      ? buttonRect.left
      : buttonRect.right - menuRect.width

    this.menuTarget.style.top = `${top}px`
    this.menuTarget.style.left = `${Math.max(viewportPadding, left)}px`
  }

  close(event) {
    if (event && this.element.contains(event.target)) return
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
      this.menuTarget.style.top = ""
      this.menuTarget.style.left = ""
    }
  }

  closeOnEscape = (event) => {
    if (event.key === "Escape") this.close()
  }
}
