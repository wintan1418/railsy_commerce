import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["revenueCanvas", "statusCanvas"]
  static values = {
    revenueData: Array,
    statusData: Object
  }

  async connect() {
    if (typeof Chart === "undefined") {
      await this._loadChartJS()
    }
    this._renderRevenueChart()
    this._renderStatusChart()
  }

  _loadChartJS() {
    return new Promise((resolve, reject) => {
      const script = document.createElement("script")
      script.src = "https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"
      script.onload = resolve
      script.onerror = reject
      document.head.appendChild(script)
    })
  }

  _renderRevenueChart() {
    if (!this.hasRevenueCanvasTarget || !this.revenueDataValue.length) return

    const labels = this.revenueDataValue.map(d => d[0])
    const data = this.revenueDataValue.map(d => (d[1] / 100).toFixed(2))

    new Chart(this.revenueCanvasTarget, {
      type: "line",
      data: {
        labels,
        datasets: [{
          label: "Revenue ($)",
          data,
          borderColor: "#c9a96e",
          backgroundColor: "rgba(201, 169, 110, 0.1)",
          fill: true,
          tension: 0.4,
          borderWidth: 2,
          pointRadius: 3,
          pointBackgroundColor: "#c9a96e"
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: { callback: v => "$" + v }
          },
          x: {
            ticks: { maxTicksLimit: 10 }
          }
        }
      }
    })
  }

  _renderStatusChart() {
    if (!this.hasStatusCanvasTarget || !this.statusDataValue) return

    const entries = Object.entries(this.statusDataValue)
    if (!entries.length) return

    const labels = entries.map(e => e[0])
    const data = entries.map(e => e[1])
    const colors = {
      pending: "#f59e0b",
      confirmed: "#3b82f6",
      processing: "#8b5cf6",
      shipped: "#06b6d4",
      delivered: "#10b981",
      cancelled: "#ef4444"
    }

    new Chart(this.statusCanvasTarget, {
      type: "doughnut",
      data: {
        labels,
        datasets: [{
          data,
          backgroundColor: labels.map(l => colors[l] || "#6b7280"),
          borderWidth: 0
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: "bottom",
            labels: { padding: 16, usePointStyle: true, pointStyle: "circle" }
          }
        }
      }
    })
  }
}
