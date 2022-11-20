import { Controller } from "@hotwired/stimulus"

// https://stimulus.hotwired.dev/handbook/building-something-real#implementing-a-copy-button
export default class extends Controller {
  // Stimulus will automatically create target properties returning first matching target element
  // this.buttonTarget & this.sourceTarget
  static targets = [ "button", "source" ]

  // https://stimulus.hotwired.dev/reference/values
  // pass new values in the HTML using e.g. `data-clipboard-success-duration-value="1000"`
  static values = {
    successDuration: { type: Number, default: 1000 },
    successMessage: { type: String, default: "Copied!" }
  }

  // Stimulus calls connect() method each time a controller is connected to the document
  connect() {
    // https://stimulus.hotwired.dev/reference/values#properties-and-attributes
    if (!this.hasButtonTarget) return
    this.originalContent = this.buttonTarget.innerHTML
  }

  copy(event) {
    event.preventDefault() // don't follow links
    const text = this.sourceTarget.innerHTML || this.sourceTarget.value
    // https://www.w3.org/TR/clipboard-apis/#dom-clipboard-writetext
    navigator.clipboard.writeText(text).then(() => {return this.copied()})
  }

  copied() {
    if (!this.hasButtonTarget) return

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.buttonTarget.innerText = this.successMessageValue

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalContent
    }, this.successDurationValue)
  }
}
