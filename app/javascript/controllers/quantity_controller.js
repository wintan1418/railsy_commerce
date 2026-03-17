import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  increment() {
    const current = parseInt(this.inputTarget.value) || 1
    const max = parseInt(this.inputTarget.max) || 99
    if (current < max) {
      this.inputTarget.value = current + 1
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  decrement() {
    const current = parseInt(this.inputTarget.value) || 1
    const min = parseInt(this.inputTarget.min) || 1
    if (current > min) {
      this.inputTarget.value = current - 1
      this.inputTarget.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }
}
