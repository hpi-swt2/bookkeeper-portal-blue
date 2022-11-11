// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

/*
 * Libraries
 */
import "@hotwired/turbo-rails"
import "controllers"
// You must include popper.min.js before bootstrap.js
// https://getbootstrap.com/docs/5.2/components/tooltips/
import "popper"
import "bootstrap"

/*
 * Enable Bootstrap tooltips
 * https://getbootstrap.com/docs/5.2/components/tooltips/#enable-tooltips
 */

// https://turbo.hotwired.dev/reference/events
document.addEventListener('turbo:load', function () {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
}, false);
