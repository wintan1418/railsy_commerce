import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "dot"]
  static values = {
    index: { type: Number, default: 0 },
    interval: { type: Number, default: 5000 }
  }

  connect() {
    this.showSlide(this.indexValue)
    this.startAutoplay()
  }

  disconnect() {
    this.stopAutoplay()
  }

  startAutoplay() {
    this.timer = setInterval(() => {
      this.next()
    }, this.intervalValue)
  }

  stopAutoplay() {
    if (this.timer) {
      clearInterval(this.timer)
      this.timer = null
    }
  }

  pause() {
    this.stopAutoplay()
  }

  resume() {
    this.startAutoplay()
  }

  next() {
    const nextIndex = (this.indexValue + 1) % this.slideTargets.length
    this.indexValue = nextIndex
    this.showSlide(nextIndex)
  }

  previous() {
    const prevIndex = (this.indexValue - 1 + this.slideTargets.length) % this.slideTargets.length
    this.indexValue = prevIndex
    this.showSlide(prevIndex)
  }

  goToSlide(event) {
    const index = parseInt(event.currentTarget.dataset.slideIndex, 10)
    this.stopAutoplay()
    this.indexValue = index
    this.showSlide(index)
    this.startAutoplay()
  }

  showSlide(index) {
    this.slideTargets.forEach((slide, i) => {
      if (i === index) {
        slide.classList.remove("slide-inactive")
        slide.classList.add("slide-active")
      } else {
        slide.classList.remove("slide-active")
        slide.classList.add("slide-inactive")
      }
    })

    this.dotTargets.forEach((dot, i) => {
      if (i === index) {
        dot.classList.remove("dot-inactive")
        dot.classList.add("dot-active")
      } else {
        dot.classList.remove("dot-active")
        dot.classList.add("dot-inactive")
      }
    })
  }
}
