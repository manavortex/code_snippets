// ==UserScript==
// @name         pkg: remove not-matching list results; focus search box
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Filters on distro, version and architecture. Will remove all search results not matching those from the DOM. Will also focus search field when you tab back in.
// @author       You
// @match        https://pkgs.org/*
// @match        https://ubuntu.pkgs.org
// @grant        none
// ==/UserScript==

const your_distro = "distro-ubuntu"
const your_version = "16.04"
const your_architecture = "amd64"


(function() {
    'use strict';
    setTimeout(function() {
        var $=window.jQuery
        if ($(".card-header." + your_distro).length == 0) { return; }
        $(".card-header").not("." + your_distro).parent().remove();

        $(".card-header").filter(function() { return this.innerHTML.indexOf(your_version) < 0}).parent().remove();
        $("tr").filter(function() { return this.innerHTML.indexOf(your_architecture) < 0 }).remove();
        var links = $("tr.table-active").parent().find("a");
        if (links.length <= 2) {
            links[0].click();
        }
    }, 100);
    window.addEventListener("focus", function(event) { document.getElementById("searchform-query").focus(); }, false);
})();
