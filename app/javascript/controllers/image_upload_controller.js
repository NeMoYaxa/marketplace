import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "previews"]

  connect() {
    this.files = []
  }

  select() {
    const selectedFiles = Array.from(this.inputTarget.files)
      .filter((file) => file.type.startsWith("image/"))

    this.files = [...this.files, ...selectedFiles]
    this.syncInput()
    this.renderPreviews()
  }

  renderPreviews() {
    this.previewsTarget.replaceChildren()

    this.files.forEach((file, index) => {
      const preview = document.createElement("div")
      preview.className = "relative aspect-[4/3] overflow-hidden rounded-xl border border-[#303750] bg-[#1a2034]"

      const image = document.createElement("img")
      image.className = "h-full w-full object-cover"
      image.alt = file.name
      image.src = URL.createObjectURL(file)
      image.onload = () => URL.revokeObjectURL(image.src)

      const remove = document.createElement("button")
      remove.type = "button"
      remove.className = "group/remove absolute right-2 top-2 rounded-lg border border-white/10 bg-[#080b14]/75 px-2 py-1 text-[11px] font-semibold text-white/90 opacity-0 transition hover:border-[#8a68ff] hover:bg-gradient-to-r hover:from-[#8a68ff] hover:via-[#5b8dff] hover:to-[#39d8cf] hover:shadow-[0_9px_22px_rgba(104,105,255,.34)]"
      remove.setAttribute("aria-label", `Удалить ${file.name}`)

      const icon = document.createElement("span")
      icon.className = "text-[11px] font-semibold leading-none transition-colors group-hover/remove:text-[#ff1744] group-hover/remove:drop-shadow-[0_0_6px_rgba(255,23,68,.75)]"
      icon.textContent = "✕"

      const label = document.createElement("span")
      label.className = "ml-1"
      label.textContent = "Удалить"

      remove.append(icon, label)
      remove.addEventListener("click", () => this.removeFile(index))

      preview.addEventListener("mouseenter", () => remove.classList.add("opacity-100"))
      preview.addEventListener("mouseleave", () => remove.classList.remove("opacity-100"))
      preview.addEventListener("touchstart", () => remove.classList.add("opacity-100"), { passive: true })

      preview.append(image, remove)
      this.previewsTarget.append(preview)
    })
  }

  removeFile(index) {
    this.files.splice(index, 1)
    this.syncInput()
    this.renderPreviews()
  }

  syncInput() {
    const transfer = new DataTransfer()
    this.files.forEach((file) => transfer.items.add(file))
    this.inputTarget.files = transfer.files
  }
}
