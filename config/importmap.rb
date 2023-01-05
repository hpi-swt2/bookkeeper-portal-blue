# Pin npm packages by running ./bin/importmap
# https://guides.rubyonrails.org/working_with_javascript_in_rails.html

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

# https://dev.to/coorasse/rails-7-bootstrap-5-and-importmaps-without-nodejs-4g8
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "qr-scanner", to: "https://ga.jspm.io/npm:qr-scanner@1.4.2/qr-scanner.min.js"
