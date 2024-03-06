import sublime, sublime_plugin
import re

class RemoveLinesWithPartialCommand(sublime_plugin.TextCommand):

    def getReplacementText(self, args, view):
        if args != None and "".join(args).strip() != "":
            return "".join(args)
            
        for region in view.sel():
            if region.empty():
                continue

            # Extract the selected text
            partial_string = view.substr(region)
            if partial_string != None and partial_string.strip() != "":
                return partial_string
            
        return None

    def run(self, edit, args=None):
        partial_string = self.getReplacementText(args, self.view)
        if partial_string == None or partial_string.strip() == "":
            return

        # Convert the selected text to a regex pattern
        pattern = re.compile(re.escape(partial_string))
        
        for region in self.view.sel():
            if region.empty():
                continue
            
            # Find all lines in the current view
            all_lines = self.view.lines(sublime.Region(0, self.view.size()))
            
            for line in reversed(all_lines):  # Iterate in reverse to avoid affecting indices
                line_text = self.view.substr(line)
                if pattern.search(line_text):
                    # If the line contains the pattern, remove it
                    self.view.erase(edit, self.view.full_line(line))

class RemoveLinesWithoutPartialCommand(sublime_plugin.TextCommand):

    def getReplacementText(self, args, view):
        if args != None and "".join(args).strip() != "":
            return "".join(args)
            
        for region in view.sel():
            if region.empty():
                continue

            # Extract the selected text
            partial_string = view.substr(region)
            if partial_string != None and partial_string.strip() != "":
                return partial_string
            
        return None

    def run(self, edit, args=None):
        partial_string = self.getReplacementText(args, self.view)
        if partial_string == None or partial_string.strip() == "":
            return

        # Convert the selected text to a regex pattern
        pattern = re.compile(re.escape(partial_string))
        
        for region in self.view.sel():
            if region.empty():
                continue
            
            # Find all lines in the current view
            all_lines = self.view.lines(sublime.Region(0, self.view.size()))
            
            for line in reversed(all_lines):  # Iterate in reverse to avoid affecting indices
                line_text = self.view.substr(line)
                if not pattern.search(line_text):
                    # If the line contains the pattern, remove it
                    self.view.erase(edit, self.view.full_line(line))

                
                

