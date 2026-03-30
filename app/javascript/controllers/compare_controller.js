import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "bar", "count"]

  connect() {
    this._loadSelected()
    this._updateUI()
  }

  toggle(event) {
    const id = event.target.dataset.productId
    let selected = this._getSelected()

    if (event.target.checked) {
      if (selected.length >= 4) {
        event.target.checked = false
        alert("You can compare up to 4 products at a time.")
        return
      }
      selected.push(id)
    } else {
      selected = selected.filter(s => s !== id)
    }

    localStorage.setItem("compare_ids", JSON.stringify(selected))
    this._updateUI()
  }

  compare() {
    const selected = this._getSelected()
    if (selected.length < 2) {
      alert("Please select at least 2 products to compare.")
      return
    }
    window.location.href = `/compare?ids=${selected.join(",")}`
  }

  clear() {
    localStorage.removeItem("compare_ids")
    this.checkboxTargets.forEach(cb => cb.checked = false)
    this._updateUI()
  }

  _getSelected() {
    try {
      return JSON.parse(localStorage.getItem("compare_ids") || "[]")
    } catch {
      return []
    }
  }

  _loadSelected() {
    const selected = this._getSelected()
    this.checkboxTargets.forEach(cb => {
      cb.checked = selected.includes(cb.dataset.productId)
    })
  }

  _updateUI() {
    const selected = this._getSelected()
    if (this.hasBarTarget) {
      if (selected.length > 0) {
        this.barTarget.classList.remove("translate-y-full")
        this.barTarget.classList.add("translate-y-0")
      } else {
        this.barTarget.classList.add("translate-y-full")
        this.barTarget.classList.remove("translate-y-0")
      }
    }
    if (this.hasCountTarget) {
      this.countTarget.textContent = selected.length
    }
  }
}
