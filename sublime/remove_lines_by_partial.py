import re
import sys
import sublime
import sublime_plugin

class RemoveLinesByPartialCommand(sublime_plugin.TextCommand):
  regex = ""

  def on_done(self, user_input):
    sublime.status_message("removing lines containing " + user_input)
    self.regex = "(.*({}).*)($[\r\n])?".format(user_input)
    self.remove_lines_from_buffer()
    self.regex = ""

  def remove_lines_from_buffer(self):

      region = sublime.Region(0, self.view.size())
      for line in self.view.find_all(self.regex, 0):
        self.view.replace(self.edit, line, "")

  def run(self, edit):
    self.edit = edit
    self.view.window().show_input_panel("remove lines containing", '', self.on_done, None, None)
