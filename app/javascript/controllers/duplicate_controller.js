import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ 'duplicate' ];

  static values = { url: String };

 copyEvent() {
   console.log("inside duplicate");
    
  }
}