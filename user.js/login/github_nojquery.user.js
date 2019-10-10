// ==UserScript==
// @name         AutoLogin: Github
// @namespace    https://github.com/
// @version      0.1 
// @author       manavortex
// @match        https://github.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    var loginLink = document.querySelector("a[href='/login']");
    if (loginLink && window.location.href == window.location) {
        loginLink.click();
    }
    setTimeout(function() {
        var flashError = document.querySelector(".ajax-error-message");
        var hasError = (!flashError || flashError.offsetParent !== null);
        var passwd = document.querySelector("#password");
        if (!hasError && passwd && passwd.textLength > 0 ) {
            document.querySelector("input[type='submit']").click();
        }
    }, 600);
})();
