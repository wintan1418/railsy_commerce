import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "badge", "messages", "input"]

  connect() {
    this.open = false
    this.loadMessages()
    // Poll for new messages every 10 seconds
    this.poller = setInterval(() => { if (this.open) this.loadMessages() }, 10000)
  }

  disconnect() {
    if (this.poller) clearInterval(this.poller)
  }

  toggle() {
    this.open = !this.open
    this.panelTarget.classList.toggle("hidden", !this.open)
    if (this.open) {
      this.loadMessages()
      this.inputTarget.focus()
    }
  }

  close() {
    this.open = false
    this.panelTarget.classList.add("hidden")
  }

  async loadMessages() {
    try {
      const response = await fetch("/chat/messages")
      if (response.ok) {
        const html = await response.text()
        this.messagesTarget.innerHTML = html
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
      }
    } catch (e) {
      // silent fail
    }
  }

  async send(event) {
    event.preventDefault()
    const message = this.inputTarget.value.trim()
    if (!message) return

    this.inputTarget.value = ""
    this.inputTarget.disabled = true

    // Optimistically show the message
    this.messagesTarget.insertAdjacentHTML("beforeend",
      `<div class="flex justify-end mb-3"><div class="max-w-[80%] rounded-2xl rounded-br-md px-4 py-2.5 text-sm" style="background: var(--gold); color: var(--black);">${this.escapeHtml(message)}</div></div>
       <div class="flex justify-start mb-3"><div class="max-w-[80%] rounded-2xl rounded-bl-md px-4 py-2.5 text-sm bg-gray-100" style="color: var(--text-body);"><span class="inline-block animate-pulse">Typing...</span></div></div>`)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight

    try {
      const token = document.querySelector('meta[name="csrf-token"]').content
      await fetch("/chat", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded", "X-CSRF-Token": token },
        body: `message=${encodeURIComponent(message)}`
      })
      await this.loadMessages()
    } catch (e) {
      // silent fail
    }

    this.inputTarget.disabled = false
    this.inputTarget.focus()
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
