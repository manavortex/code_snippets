// ==UserScript==
// @name         pkg: download link
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://ubuntu.pkgs.org/*.deb.html
// @grant        GM_setClipboard
// ==/UserScript==


// note: GM_setClipboard breaks window.jQuery, so do without

(function() {
    'use strict';
    setTimeout(function() {

        var link = getLinkFromTable(findDownloadTable());
        if (!link) { return;}
        window.scrollTo({ top: link.closest("table").previousElementSibling.offsetTop, left: 0, behavior: "smooth" });

        var filename = link.href.substring(link.href.lastIndexOf("/")+1);
        GM_setClipboard(filename);
        SaveToDisk(link, filename);
    }, 200);

    window.addEventListener("focus", function(event) { document.getElementById("searchform-query").focus(); }, false);
})();

function getLinkFromTable(table) {
    if (!table) { return null;}
    var links = table.getElementsByTagName("a");
    if (links.length == 1) { return links[0]; }

    var i, link;
    for (i=0; i < links.length; i++) {
        link = links[i];
        if (link.closest("tr").innerHTML.indexOf("pdate") < 0 && link.href.indexOf(".deb") == link.href.length -4) {
            return link;
        }
    }
    return null;
}
function findDownloadTable() {
    var tables = document.querySelectorAll("#view_packages_info table");
    var table, sib, i;
    for (i = 0; i < tables.length; i++) {
        table = tables[i];
        sib = table.previousElementSibling;
        if ("H2" != sib.tagName || sib.innerHTML.indexOf("Download") < 0) { continue; }
        return table;
    }
    return null;
}


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

