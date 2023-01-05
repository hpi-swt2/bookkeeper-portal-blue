import QrScanner from 'qr-scanner';

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  initialize() {
    this.qrScanner = null;
  }

  _isPositiveInteger(string) {
    const castedString = Number(string);
    return !(castedString == NaN || castedString < 0 || !Number.isInteger(castedString))
  }

  _found(result) {
    const split_result = result.data.split(":")
    if (split_result.length != 2) {
      return;
    }
    if (split_result[0] != "item" || !this._isPositiveInteger(split_result[1])) {
      return;
    }
    const item_id = split_result[1];
    this.close();
    window.location.href = "/items/" + item_id;
  }

  open() {
    this.qrScanner = new QrScanner(
      document.getElementById("qrvideo"),
      result => this._found(result),
      { highlightCodeOutline: true, highlightScanRegion: true, maxScansPerSecond: 10},
    );
    this.qrScanner.start();
  }

  close() {
    if (this.qrScanner != null) {
      this.qrScanner.stop();
      this.qrScanner.destroy();
      this.qrScanner = null;
    }
  }

  toggleFlash() {
    if (this.qrScanner.hasFlash()) {
      this.qrScanner.toggleFlash();
    }
  }
}