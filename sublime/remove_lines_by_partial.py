import sublime
import sublime_plugin


class ReplaceLinesWithPartialCommand(sublime_plugin.TextCommand):
  pluginText = "remove lines containing "

  # Check all links in view
  def check_lines(self, edit, regex_arg):
    
    v = self.view

    # Find all lines in view
    regions = [ sublime.Region(0, v.size()) ]

    for region in reversed(regions):
      lines = v.split_by_newlines(region)

      for line in reversed(lines):
        if regex_arg in v.substr(line):
          v.erase(edit, v.full_line(line))

  def run(self, edit, *regex_arg):
    if self.view.is_read_only() or self.view.size () == 0 : return
    self.check_lines(edit, self.view.substr(self.view.sel()[0]))

class ReplaceLinesWithoutPartialCommand(sublime_plugin.TextCommand):
  pluginText = "remove lines NOT containing "

  # Check all links in view
  def check_lines(self, edit, regex_arg):
    
    v = self.view

    # if there's no non-empty selection, filter the whole document

    regions = [ sublime.Region(0, v.size()) ]

    for region in reversed(regions):
      lines = v.split_by_newlines(region)

      for line in reversed(lines):
        if regex_arg not in v.substr(line):
          v.erase(edit, v.full_line(line))

  
  def run(self, edit):
    if self.view.is_read_only() or self.view.size () == 0 : return
    self.check_lines(edit, self.view.substr(self.view.sel()[0]))
