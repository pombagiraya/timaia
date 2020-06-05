require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")
require("building")
import "bootstrap";

import { initMapbox } from '../plugins/init_mapbox';

document.addEventListener('turbolinks:load', () => {
  initMapbox();
});