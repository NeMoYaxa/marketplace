import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const date = new Date(this.element.dateTime)
    if (Number.isNaN(date.getTime())) return

    const options = {
      day: "2-digit",
      month: "short",
      hour: "2-digit",
      minute: "2-digit"
    }

    if (date.getFullYear() !== new Date().getFullYear()) {
      options.year = "numeric"
    }

    this.element.textContent = new Intl.DateTimeFormat("ru-RU", options).format(date)
  }
}
