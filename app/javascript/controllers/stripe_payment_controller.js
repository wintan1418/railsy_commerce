import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { key: String }

  async connect() {
    if (!this.keyValue) return

    // Load Stripe.js dynamically
    if (!window.Stripe) {
      const script = document.createElement("script")
      script.src = "https://js.stripe.com/v3/"
      script.onload = () => this.initStripe()
      document.head.appendChild(script)
    } else {
      this.initStripe()
    }
  }

  initStripe() {
    this.stripe = window.Stripe(this.keyValue)
    const elements = this.stripe.elements()

    this.card = elements.create("card", {
      style: {
        base: {
          fontFamily: "'DM Sans', system-ui, sans-serif",
          fontSize: "15px",
          color: "#3a3a3a",
          "::placeholder": { color: "#6b6b6b" }
        },
        invalid: { color: "#c0392b" }
      }
    })

    this.card.mount("#stripe-card-element")
    this.card.on("change", (event) => {
      const errors = document.getElementById("card-errors")
      errors.textContent = event.error ? event.error.message : ""
    })
  }

  disconnect() {
    if (this.card) this.card.destroy()
  }
}
