import { Controller } from "@hotwired/stimulus"
import { visit } from "@hotwired/turbo"

export default class extends Controller {
  get notebook() {
    return this.element.querySelector("#notebook-page")
  }

  connect() {
    if (this.notebook && window.flipDirection === "prev") {
      this.notebook.classList.add("animate-prev-in")
      
      setTimeout(() => {
        this.notebook.classList.remove("animate-prev-in")
        window.flipDirection = null
      }, 1200) 
    }
  }

  flip(event) {
    const page = this.notebook
    if (!page) return

    const currentUrl = new URL(window.location.href)
    const targetUrl = new URL(event.currentTarget.href)
    const currentDate = currentUrl.searchParams.get("date") || new Date().toISOString().split('T')[0]
    const targetDate = targetUrl.searchParams.get("date")
    const isNext = targetDate > currentDate

    if (isNext) {
      // ------------------------------------------------
      // 【未来へ行く時】
      // ------------------------------------------------
      event.preventDefault()

      const rect = page.getBoundingClientRect()
      const clone = page.cloneNode(true)
      clone.removeAttribute('id') 
      
      Object.assign(clone.style, {
        position: 'fixed',
        top: `${rect.top}px`, left: `${rect.left}px`,
        width: `${rect.width}px`, height: `${rect.height}px`,
        zIndex: '9999', margin: '0',
        transformOrigin: 'left center', pointerEvents: 'none',
        transition: 'none'
      })
      
      document.body.appendChild(clone)
      
      requestAnimationFrame(() => {
        requestAnimationFrame(() => {
          clone.classList.add("animate-next-out")
        })
      })

      page.style.opacity = '0'
      visit(targetUrl, { frame: "main-interface", action: "advance" })

      setTimeout(() => { clone.remove() }, 1600) 

    } else {
      // ------------------------------------------------
      // 【過去へ戻る時】
      // ------------------------------------------------
      const rect = page.getBoundingClientRect()
      const clone = page.cloneNode(true)
      clone.removeAttribute('id')

      Object.assign(clone.style, {
        position: 'fixed',
        top: `${rect.top}px`, left: `${rect.left}px`,
        width: `${rect.width}px`, height: `${rect.height}px`,
        zIndex: '0', 
        margin: '0', pointerEvents: 'none'
      })

      document.body.appendChild(clone)

      window.flipDirection = "prev"

      setTimeout(() => {
        clone.remove()
      }, 1200)
    }
  }
}