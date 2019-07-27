import re
import sys
import sublime
import sublime_plugin

#{ "keys": ["super+shift+r"], "command": "remove_lines_by_partial" },
#{ "keys": ["super+shift+ctrl+r"], "command": "remove_lines_without_partial" },

class RemoveLinesByPartialCommand(sublime_plugin.TextCommand):

  pluginText = "remove lines containing "

  def on_done(self, user_input):
    sublime.status_message(self.pluginText + user_input)
    regex = "(.*({}).*)($[\r\n])?".format(user_input)
    for line in self.view.find_all(regex, 0):
      self.view.replace(self.edit, line, "")

  def run(self, edit):
    self.edit = edit
    self.view.window().show_input_panel(self.pluginText, '', self.on_done, None, None)


class RemoveLinesWithoutPartialCommand(sublime_plugin.TextCommand):
  pluginText = "remove lines _NOT_ containing "

  def on_done(self, user_input):
    sublime.status_message(self.pluginText + user_input)
    regex = "^((?!|{}).)*$".format(user_input)
    for line in self.view.find_all(regex, 0):
      sublime.status_message(self.pluginText + user_input)
      self.view.replace(self.edit, line, "")

  def run(self, edit):
    self.edit = edit
    self.view.window().show_input_panel(self.pluginText, '', self.on_done, None, None)
