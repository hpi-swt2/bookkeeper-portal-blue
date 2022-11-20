/*  
 * Tooltips rely on the third party library Popper for positioning.
 * Tooltips are opt-in for performance reasons, so you must initialize them yourself.
 * https://getbootstrap.com/docs/5.2/components/tooltips/
 */

import { Controller } from "@hotwired/stimulus";

/*
 * Connect to all elements with data-controller="tooltip"
 * instead of the default `data-bs-toggle="tooltip"`
 */

// Connects to data-controller="tooltip" HTML elements
export default class extends Controller {
  connect() {
    // Create a new Bootstrap Tooltip instance
    // (https://getbootstrap.com/docs/5.2/components/tooltips/#methods)
    // this.element is the HTML element tagged with `data-controller`
    // (https://stimulus.hotwired.dev/reference/controllers#properties)
    // The library reads config from `data-bs-*` attributes
    // (https://getbootstrap.com/docs/5.2/components/tooltips/#directions)
    bootstrap.Tooltip.getOrCreateInstance(this.element);
  }
}