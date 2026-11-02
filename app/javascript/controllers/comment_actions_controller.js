import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["deleteButton"]

  connect() {
    const userId = document.querySelector('meta[name="current-user-id"]')?.content
    const isAdmin = document.querySelector('meta[name="current-user-admin"]')?.content === "true"

    if (isAdmin || userId === this.element.dataset.authorId) {
      this.deleteButtonTarget.classList.remove("hidden")
    }
  }
}
