// ==UserScript==
// @name         AutoLogin: FreeCommander
// @version      1.0
// @author       manavortex
// @match        https://freecommander.com/donors/*
// @grant        none
// ==/UserScript==

var $ = window.jQuery;
(function() {
    'use strict';
    setTimeout(function() {
        var passwordField = document.getElementById('amember-pass');
        var error = document.querySelector('.am-errors am-login-errors');
        if (null !== passwordField && passwordField.textLength > 0 && null === error ) {
            document.querySelector("input[type='submit']").click();
            return;
        }
        var linkToDownloads = document.querySelector('a[href*="/donors/page/downloads"]');
        if (null !== linkToDownloads) {
            linkToDownloads.click();
            return;
        }
        var downloadLink = $('a:contains("FreeCommanderXE-64-donor_setup")');
        if (null !== downloadLink && downloadLink.length > 0) {
            downloadLink[0].click();
        }
    }, 1500);
})();
