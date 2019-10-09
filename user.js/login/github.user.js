// ==UserScript==
// @name         Github: Auto-login
// @namespace    https://github.com/
// @version      0.1
// @author       manavortex
// @match        https://github.com/login
// @grant        none
// ==/UserScript==

var $ = window.jQuery;
(function() {
    'use strict';
    setTimeout(function() {
        var passwordField = document.getElementById('password');
        var error = document.querySelector('.flash flash-full.flash-error');
        if (null !== passwordField && passwordField.textLength > 0 && null === error ) {
            document.querySelector("input[type='submit']").click();
            return;
        }
    }, 1000);
})();
