// ==UserScript==
// @name        No New Tabs
// @description Stops a site from ever opening a new tab (or window) on links.
//              This allows you to control when to open a new window or tab.
// @match       *://*/*
// @run-at      document-start
// ==/UserScript==

// Convert all links to not open in a new tab or window.
setTimeout( () => document.querySelectorAll( 'a[target="_blank"]' ).forEach( ( link ) => link.removeAttribute('target') ), 250 );

// Top window.open from opening new windows.
window.open = ( url ) => window.location.href = url;
