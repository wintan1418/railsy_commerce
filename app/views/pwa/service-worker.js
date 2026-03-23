const CACHE_VERSION = "v1"
const CACHE_NAME = `railsycommerce-${CACHE_VERSION}`

// Assets to cache on install
const PRECACHE_URLS = [
  "/",
  "/products"
]

// Install — precache key pages
self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(PRECACHE_URLS)
    }).then(() => self.skipWaiting())
  )
})

// Activate — clean old caches
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key))
      )
    }).then(() => self.clients.claim())
  )
})

// Fetch — network first, fallback to cache
self.addEventListener("fetch", (event) => {
  // Skip non-GET and cross-origin requests
  if (event.request.method !== "GET") return
  if (!event.request.url.startsWith(self.location.origin)) return

  // Skip admin, API, and auth routes
  const url = new URL(event.request.url)
  if (url.pathname.startsWith("/admin") ||
      url.pathname.startsWith("/api") ||
      url.pathname.startsWith("/session") ||
      url.pathname.startsWith("/auth")) return

  event.respondWith(
    fetch(event.request)
      .then((response) => {
        // Cache successful responses
        if (response.ok) {
          const clone = response.clone()
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone))
        }
        return response
      })
      .catch(() => {
        // Offline fallback
        return caches.match(event.request).then((cached) => {
          return cached || caches.match("/")
        })
      })
  )
})

// Push notifications
self.addEventListener("push", async (event) => {
  const { title, options } = await event.data.json()
  event.waitUntil(self.registration.showNotification(title, options))
})

self.addEventListener("notificationclick", (event) => {
  event.notification.close()
  event.waitUntil(
    clients.matchAll({ type: "window" }).then((clientList) => {
      for (const client of clientList) {
        if (client.url === event.notification.data?.path && "focus" in client) {
          return client.focus()
        }
      }
      if (clients.openWindow) {
        return clients.openWindow(event.notification.data?.path || "/")
      }
    })
  )
})
