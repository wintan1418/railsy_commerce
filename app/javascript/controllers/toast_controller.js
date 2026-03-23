import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Auto-dismiss after 3 seconds
    this.timeout = setTimeout(() => this.dismiss(), 3000)
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-y-2")
    setTimeout(() => this.element.remove(), 300)
  }
}
