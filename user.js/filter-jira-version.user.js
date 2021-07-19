// ==UserScript==
// @name         Jira: Filter versions
// @namespace    http://tampermonkey.net/
// @version      0.1
// @match        https://collab.cbb.de/jira/projects/*?selectedItem=com.atlassian.jira.jira-projects-plugin:release-page*
// @match        https://collab.cbb.de/jira/plugins/servlet/project-config/*/versions*
// @require      http://code.jquery.com/jquery-3.5.1.min.js
// @require      https://gist.github.com/raw/2625891/waitForKeyElements.js
// @grant        GM_addStyle
// ==/UserScript==

/* eslint-disable no-undef */

const $ = window.jQuery;
const doc = document;

const selectMap = {};

function sortFunc(a, b) {
    const text1 = $(a).text();
    const text2 = $(b).text();
    if(text1 < text2) { return -1; }
    if(text1 > text2) { return 1; }
    return 0;
  }

function filterSelectOptions(select, compareString='') {

  if (!select) return;
  let opts = selectMap[select.name] || select.options;

  let filteredOpts = Object.values(opts).filter((option) => '' === compareString || $(option).text().indexOf(compareString) >= 0).sort(sortFunc);


  select.options = {};
  for (let i=0; i<Object.keys(opts).length; i++) {
    if (i <= filteredOpts.length) {
      select.options[i] = filteredOpts[i];
    } else {
      select.options.remove(i);
    }
  }

}

const selectNames = ['idsToMerge', 'idMergeTo'];
function addFilterFieldBefore(fieldGroup, idx) {
  let select;
  for (let i = 0; i < selectNames.length; i++) {
    $(fieldGroup).find(`[name='${selectNames[i]}']`).each((idx, el) => { select = select || el; });
  }
  if (!select) return;

  selectMap[select.name] = select.options;

  const otherGroup = doc.createElement('div');
  const label = doc.createElement('label');
  const input = doc.createElement('input');

  label.innerText = 'Filter';

  input.type = 'text';

  $(otherGroup).addClass('field-group').addClass('filter');
  $(otherGroup).append(label);
  $(otherGroup).append(input);
  $(otherGroup).insertBefore(fieldGroup);

  const multiSelect = $(fieldGroup).find('.jira-multi-select');
  $(multiSelect).click(function() {
    filterSelectOptions(select, input.value);
  });

  $( input).keyup(function(evt) {
    filterSelectOptions(select, input.value);
  });

}

(function() {
  'use strict';

  GM_addStyle('form.aui .field-group > label { word-wrap: initial;}')
  GM_addStyle('.hidden { display: none important! }')

  waitForKeyElements("#versionsMergeDialog", function(el) {
    // console.log("versionsMergeDialog");
    $(el).css('width', '40em');
    // console.log(el);

    // iterate over field group selects
    $(el).find('.field-group').each((idx, fieldGroup) => {
      addFilterFieldBefore(fieldGroup, idx);
    })

  });

  waitForKeyElements("#idsToMerge-suggestions", function(el) {
    console.log(el);
    // debugger;
  });

})();
