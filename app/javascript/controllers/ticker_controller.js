import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.index = 0
    this.timer = setInterval(() => this.next(), 3500)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  next() {
    const current = this.messageTargets[this.index]
    current.classList.remove("opacity-100", "translate-y-0")
    current.classList.add("opacity-0", "-translate-y-full")

    this.index = (this.index + 1) % this.messageTargets.length
    const next = this.messageTargets[this.index]
    next.classList.remove("opacity-0", "translate-y-full", "-translate-y-full")
    next.classList.add("opacity-100", "translate-y-0")
  }
}
