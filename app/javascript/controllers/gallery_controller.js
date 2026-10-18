import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "counter", "previous", "next", "thumbnails", "modal", "modalImage"]
  static values = { images: Array }

  connect() {
    this.index = 0
    this.touchStartX = null
    this.update()
  }

  select(event) {
    this.index = Number(event.currentTarget.dataset.galleryIndex)
    this.update()
  }

  previous() {
    this.index = Math.max(0, this.index - 1)
    this.update()
  }

  next() {
    this.index = Math.min(this.imagesValue.length - 1, this.index + 1)
    this.update()
  }

  keydown(event) {
    if (event.key === "Escape") this.close()
    if (event.key === "ArrowLeft") this.previous()
    if (event.key === "ArrowRight") this.next()
  }

  touchstart(event) {
    this.touchStartX = event.changedTouches[0].screenX
  }

  touchend(event) {
    if (this.touchStartX === null) return
    const distance = event.changedTouches[0].screenX - this.touchStartX
    if (Math.abs(distance) > 45) distance > 0 ? this.previous() : this.next()
    this.touchStartX = null
  }

  update() {
    if (!this.hasImageTarget) return
    this.imageTarget.src = this.imagesValue[this.index]
    if (this.hasModalImageTarget) this.modalImageTarget.src = this.imagesValue[this.index]
    this.counterTarget.textContent = `${this.index + 1} / ${this.imagesValue.length}`
    this.previousTarget.disabled = this.index === 0
    this.nextTarget.disabled = this.index === this.imagesValue.length - 1
    this.thumbnailsTarget.querySelectorAll("[data-gallery-index]").forEach((thumbnail, index) => {
      thumbnail.classList.toggle("opacity-60", index !== this.index)
    })
  }

  open() {
    if (!this.hasModalTarget) return
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    if (!this.hasModalTarget) return
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  closeOnBackdrop(event) {
    if (event.target !== event.currentTarget) return
    this.close()
  }
}
