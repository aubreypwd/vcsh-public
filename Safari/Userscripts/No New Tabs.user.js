// ==UserScript==
// @name        No New Tabs
// @description Stops a site from ever opening a new tab (or window) on links.
//              This allows you to control when to open a new window or tab.
// @match       *://*/*
// @run-at      document-start
// ==/UserScript==

( function() {
	'use strict';

	/**
	 * Override window.open to prevent new windows or tabs.
	 * Instead, navigate in the current tab if a URL is provided.
	 */
	window.open = function( url ) {
		if ( url ) {
			location.href = url;
		}

		// Return null to prevent default window.open behavior.
		return null;
	};

	/**
	 * Remove target attributes that open links in new tabs/windows.
	 *
	 * @param {Element} root - The root element to scan from.
	 */
	function sanitize_links( root ) {
		document.querySelectorAll( 'a[target]' ).forEach( function( el ) {
			el.removeAttribute( 'target' );
		} );
	}

	/**
	 * Run on initial page load to sanitize existing links.
	 */
	addEventListener( 'DOMContentLoaded', sanitize_links );

	/**
	 * Observe DOM changes and sanitize any newly added links.
	 */
	new MutationObserver( function( mutations ) {
		mutations.forEach( function( mutation ) {
			mutation.addedNodes.forEach( function( node ) {
				if ( node.nodeType !== 1 ) {
					sanitize_links( node );
				}
			} );
		} );
	} ).observe( 
        document.documentElement, 
        {
		    childList: true,
		    subtree: true,
	    } 
    );

} )();