import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  connect() {
    this.open = false
    this._clickOutside = this._clickOutside.bind(this)
    document.addEventListener("click", this._clickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this._clickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.open = !this.open
    this._update()
  }

  _clickOutside(event) {
    if (this.open && !this.element.contains(event.target)) {
      this.open = false
      this._update()
    }
  }

  _update() {
    if (this.open) {
      this.menuTarget.classList.remove("invisible", "opacity-0")
      this.menuTarget.classList.add("visible", "opacity-100")
    } else {
      this.menuTarget.classList.add("invisible", "opacity-0")
      this.menuTarget.classList.remove("visible", "opacity-100")
    }
  }
}
