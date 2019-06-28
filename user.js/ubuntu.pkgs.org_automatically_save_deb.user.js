// ==UserScript==
// @name         pkg: download link
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://ubuntu.pkgs.org/*.deb.html
// @grant    GM_setClipboard
// ==/UserScript==


(function() {
    'use strict';
    setTimeout(function() {

        var loc = window.location.toString();
        var filename = loc.substring(loc.lastIndexOf("/")+1).replace(".html", "");
        var link = document.querySelector('a[href*="' + filename + '"]');
        var header = link.closest("table").previousElementSibling;

        window.scrollTo({ top: header.offsetTop, left: 0, behavior: "smooth" });
        GM_setClipboard(filename);
        SaveToDisk(link, filename);
    }, 200);
})();


// credit goes to https://stackoverflow.com/questions/35453249/how-to-download-file-using-javascript-with-proper-readable-content
function SaveToDisk(fileURL, fileName) {
    // for non-IE
    if (!window.ActiveXObject) {
        var save = document.createElement('a');
        save.href = fileURL;
        save.download = fileName || 'unknown';
        save.style = 'display:none;opacity:0;color:transparent;';
        (document.body || document.documentElement).appendChild(save);

        if (typeof save.click === 'function') {
            save.click();
        } else {
            save.target = '_blank';
            var event = document.createEvent('Event');
            event.initEvent('click', true, true);
            save.dispatchEvent(event);
        }

        (window.URL || window.webkitURL).revokeObjectURL(save.href);
    }

    // for IE
    else if (!!window.ActiveXObject && document.execCommand) {
        var _window = window.open(fileURL, '_blank');
        _window.document.close();
        _window.document.execCommand('SaveAs', true, fileName || fileURL)
        _window.close();
    }
}

