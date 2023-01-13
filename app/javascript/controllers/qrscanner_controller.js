import QrScanner from 'qr-scanner';

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  initialize() {
    this.qrScanner = null;
  }

  _isPositiveInteger(string) {
    const castedString = Number(string);
    return !(castedString == NaN || !Number.isInteger(castedString) || castedString < 0)
  }

  // The qr-codes for items follow the scheme "item:[id]". id is an integer. Example: "item:7"
  _found(result) {
    const splitResult = result.data.split(":")
    if (splitResult.length != 2) {
      return;
    }
    if (splitResult[0] != "item" || !this._isPositiveInteger(splitResult[1])) {
      return;
    }
    const itemId = splitResult[1];
    this.close();
    window.location.href = "/items/" + itemId;
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
}