'use strict';

/**
 * Miscellaneous Javascript utility and helper functions used in the .html
 * pages in this demo.
 */

function onDocumentReady(fn) {
  if(document.readyState !== 'loading') {
    fn();
  } else {
    document.addEventListener('DOMContentLoaded', fn);
  }
}