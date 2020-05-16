// ==UserScript==
// @name         FreeCommander
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://freecommander.com/donors/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
     tryLogin();
     gotoDownload();
     downloadSetupX64();
})();

function findByText(searchText) {
    var aTags = document.getElementsByTagName("a");
    var found;

    for (var i = 0; i < aTags.length; i++) {
        if (aTags[i].textContent.startsWith(searchText)) {
            found = aTags[i];
            break;
        }
    }
    console.log(found);
    return found;
}

function tryLogin() {

    if (!window.location.href.endsWith("login")) { return; }
    setTimeout(function() {
        var passwdField = document.querySelector("input[type='password']");
        if (!passwdField || passwdField.value.length == 0) { return; }

        const btn = document.querySelector("input[type='submit']");
        if (btn) { btn.click(); }
    }, 1000);
}

function gotoDownload() {
    if (!window.location.href.endsWith("member")) { return; }
    setTimeout(function() {
        var downloadLink = document.querySelector("a[href*='/downloads']");
        if (downloadLink) { downloadLink.click(); }
    }, 1000);
}

function downloadSetupX64() {
 if (!window.location.href.endsWith("downloads")) { return; }
    setTimeout(function() {
        var downloadLink = findByText("FreeCommanderXE-64-donor_setup");
        if (downloadLink) { downloadLink.click(); }
    }, 1000);
}
