import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumbnail"]

  select(event) {
    event.preventDefault()
    const clickedThumb = event.currentTarget

    // Update main image source
    const newSrc = clickedThumb.dataset.imageUrl
    this.mainImageTarget.src = newSrc

    // Update active thumbnail styling
    this.thumbnailTargets.forEach(thumb => {
      thumb.classList.remove("ring-2", "ring-indigo-600")
      thumb.classList.add("ring-1", "ring-gray-200")
    })
    clickedThumb.classList.remove("ring-1", "ring-gray-200")
    clickedThumb.classList.add("ring-2", "ring-indigo-600")
  }
}
