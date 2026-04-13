import { Controller } from "@hotwired/stimulus"

// data-controller="countdown"
// data-countdown-ends-at-value="2026-04-15T12:00:00Z"
// data-countdown-target="days" / "hours" / "minutes" / "seconds"
export default class extends Controller {
  static values = { endsAt: String }
  static targets = ["days", "hours", "minutes", "seconds", "expired"]

  connect() {
    this.update()
    this.timer = setInterval(() => this.update(), 1000)
  }

  disconnect() {
    if (this.timer) clearInterval(this.timer)
  }

  update() {
    const end = new Date(this.endsAtValue).getTime()
    const now = Date.now()
    let diff = Math.max(0, Math.floor((end - now) / 1000))

    if (diff === 0) {
      if (this.hasExpiredTarget) this.expiredTarget.classList.remove("hidden")
      this.element.classList.add("countdown-expired")
      clearInterval(this.timer)
    }

    const days = Math.floor(diff / 86400); diff -= days * 86400
    const hours = Math.floor(diff / 3600); diff -= hours * 3600
    const minutes = Math.floor(diff / 60); diff -= minutes * 60
    const seconds = diff

    if (this.hasDaysTarget) this.daysTarget.textContent = String(days).padStart(2, "0")
    if (this.hasHoursTarget) this.hoursTarget.textContent = String(hours).padStart(2, "0")
    if (this.hasMinutesTarget) this.minutesTarget.textContent = String(minutes).padStart(2, "0")
    if (this.hasSecondsTarget) this.secondsTarget.textContent = String(seconds).padStart(2, "0")
  }
}
