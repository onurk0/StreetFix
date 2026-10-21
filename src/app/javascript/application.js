// Main javascript file
// served for all pages
import "@hotwired/turbo-rails"
import "controllers"

// Hide top bar when scrolling down and show it again when scrolling up
let lastScrollTop = 0

window.addEventListener("scroll", () => {
  const navbar = document.querySelector(".navbar")
  if (!navbar) return

  const st = window.scrollY
  navbar.classList.toggle("navbar-hidden", st > lastScrollTop && st > 0)
  lastScrollTop = st
})
