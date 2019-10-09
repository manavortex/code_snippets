// ==UserScript==
// @name         AutoLogin: gitlab
// @namespace    https://gitlab.com/
// @version      0.1
// @description  try to take over the world!
// @author       manavortex
// @match        https://gitlab.com/users/sign_in
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    setTimeout(function() {
    if (document.getElementById("user_password").textLength > 0) {
        document.querySelector("input[value='Sign in']").click();
    }
    }, 500);
})();
