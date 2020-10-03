// ==UserScript==
// @name         Google Docs: Dark Mode fix
// @version      0.1
// @author       manavortex
// @match        https://docs.google.com/document/d*
// @grant        GM_addStyle
// @description  Restores underline visibiltiy, changes comment highlight colour
// ==/UserScript==

const styles = {
    '.kix-lineview-decorations > *': 'border-top: 1px solid white !important',
    '.kix-commentoverlayrenderer-highlighted': [
        'background-color: rgb(255, 255, 255) !important;',
        'opacity: 1;',
        'display: block;',
    ]
}

function concatStyleAryValue(styleKey) {
    const style = styles[styleKey];
    const styleAry = (Array.isArray(style) ? style : [style]).map((str) => str.endsWith(';') ? str : `${str};`);
    let formattedAry = styleAry.length <= 1 ? `${styleAry}` : `\n\t${styleAry.join('\n\t')}\n`;
    return `${styleKey}: { ${formattedAry} }`;
}

(function() {
    'use strict';
    setTimeout(
        () => Object.keys(styles).forEach((styleKey) => GM_addStyle(concatStyleAryValue(styleKey))),
        1000,
    );
})();
