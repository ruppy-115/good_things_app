import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  get notebook() {
    return this.element.querySelector("#notebook-page")
  }

  connect() {
    // ページ遷移後、isFlippingがtrueなら「めくりきった状態」から戻す
    if (this.notebook && window.isFlipping) {
      this.notebook.classList.add("page-turning")
      
      // 0.2秒ほど「めくりきった状態」を維持してから戻すと、紙の重みが感じられます
      setTimeout(() => {
        this.notebook.classList.remove("page-turning")
        window.isFlipping = false
      }, 200)
    }
  }

  flip() {
    const page = this.notebook
    if (!page) return

    window.isFlipping = true
    page.classList.add("page-turning")
  }
}