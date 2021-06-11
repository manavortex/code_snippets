// ==UserScript==
// @name         tumblr: move permaplink pages up
// @version      0.1
// @author       manavortex
// @match        https://www.tumblr.com/customize/*
// @require      http://code.jquery.com/jquery-3.4.1.min.js
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// @grant        GM_addStyle
// @run-at       document-end
// ==/UserScript==

/* eslint-disable no-undef */

const $ = window.jQuery;

function doStuff() {

    $("#theme_params_module .module_title").click();
    $("#appearance_module .module_title").click();
    $("#open_graph_module .module_title").click();

    $("#open_graph_module").after($("#pages_module"));
    $("#theme_params_module").after($("#pages_module"));
    $("#appearance_module").after($("#pages_module"));

    $('#pages_module h3').removeClass('hidden').addClass("module_title");

    $('#current_theme_title').remove();
    $('[data-panel="theme_list"]').remove();

}

window.addEventListener('load', function() {

    GM_addStyle('.module h3:first-child.hasArrow:after { content: " ▼";}');
    GM_addStyle('.module h3:first-child.hasArrow {  border-bottom: 5px solid silver; border-radius: 5px; }');
    GM_addStyle('.module h3:first-child:not(.hasArrow):after { content: " ▲"; }');

    GM_addStyle('[data-action="new_page"] {margin-bottom: 1em;} ')
    GM_addStyle('.current_theme { padding: 0 8px; } ')
    GM_addStyle('#edit_html_button { font-size: 1.7em; line-height: 2em; } ')
    GM_addStyle('#edit_html_button:after { vertical-align: text-top; font-size: 0.6em; line-height: inherit; }')

    $(".module .module_title").click((evt) => {
        $(evt.target).siblings('.fieldset').toggleClass('hidden');
        $(evt.target).toggleClass('hasArrow');
    });

    setTimeout(doStuff, 1000);
}, false);
