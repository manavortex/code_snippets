import re
import sys
import sublime
import sublime_plugin

#{ "keys": ["super+shift+r"], "command": "remove_lines_by_partial" },
#{ "keys": ["super+shift+ctrl+r"], "command": "remove_lines_without_partial" },

class ReplaceLinesCommand(sublime_plugin.TextCommand):
  # Check all links in view
  def check_lines(self, edit, regex_arg):

    
    v = self.view

    # Find all lines in view
    regions = [s for s in v.sel() if not s.empty()]

  	# if there's no non-empty selection, filter the whole document
    if len(regions) == 0:
    	regions = [ sublime.Region(0, v.size()) ]

    for region in reversed(regions):
      lines = v.split_by_newlines(region)

      for line in reversed(lines):
        if regex_arg in v.substr(line):
          v.erase(edit, v.full_line(line))

  def run(self, edit, regex_arg):
    if self.view.is_read_only() or self.view.size () == 0:
      return
    self.check_lines (edit, regex_arg)
