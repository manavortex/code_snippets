#
# Script to add appearances to ent files via json
# By Simarilius and Manavortex
# Feb 2023
#

import json
import os
import copy
import shutil

# gui imports
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog as fd
from tkinter import messagebox
from idlelib.tooltip import Hovertip
root = tk.Tk()
root.title('Ent file app updater')
root.resizable(True, True)
root.geometry('400x600')

filetypes = (
        ('json files', '*.ent.json'),
        ('All files', '*.*')
    )

path = fd.askopenfilename(initialdir='E:\\path\\to\\your\\folder',        filetypes=filetypes)


appearanceNames = ['black', 'white', 'blue', 'green', "yellow", "red", "pink", "purple", "brown"]


'''
  ________                __      _                __    _ __ 
 /_  __/ /_  ___     ____/ /___  (_)___  ____ _   / /_  (_) /_
  / / / __ \/ _ \   / __  / __ \/ / __ \/ __ `/  / __ \/ / __/
 / / / / / /  __/  / /_/ / /_/ / / / / / /_/ /  / /_/ / / /_  
/_/ /_/ /_/\___/   \__,_/\____/_/_/ /_/\__, /  /_.___/_/\__/  
                                      /____/                  
'''


class AddAppsToMesh:
    def __init__(self):
        self.appearanceNames = appearanceNames
        self.replaceme="VARIANT"
        self.appearances=None


    
    
    def aprocess(self,path,outpath):
        if os.path.exists(path):
            if not os.path.isfile("{}.orig".format(path)):
                shutil.copy(path, "{}.orig".format(path))
            else:
                os.remove(path) 
                shutil.copy("{}.orig".format(path), path)

        with open(path,'r') as f: 
            j=json.load(f)
   

        t=j['Data']['RootChunk']
        appearances=t['appearances']
        i = 0

        for _app in appearances:
            if (not replaceme in _app['appearanceName']):
                continue
            original =  copy.deepcopy(_app)
            for appearanceName in self.appearanceNames:
                app =  copy.deepcopy(original)

                app['appearanceName']                   = app['appearanceName'].replace(self.replaceme, appearanceName)
                app['name']                             = app['name'].replace(self.replaceme, appearanceName)
                app['appearanceResource']['DepotPath']  = app['appearanceResource']['DepotPath'].replace(self.replaceme, appearanceName)
                t['appearances'].append(app)

        with open(outpath, 'w') as outfile:
            json.dump(j, outfile,indent=2)

        messagebox.showinfo(title='Export Complete', message='The Variants have been added.')


'''

  ________            ______                          __    _ __ 
 /_  __/ /_  ___     / ____/___  ____  ___  __  __   / /_  (_) /_
  / / / __ \/ _ \   / / __/ __ \/ __ \/ _ \/ / / /  / __ \/ / __/
 / / / / / /  __/  / /_/ / /_/ / /_/ /  __/ /_/ /  / /_/ / / /_  
/_/ /_/ /_/\___/   \____/\____/\____/\___/\__, /  /_.___/_/\__/  
                                         /____/                  
'''
root.test=AddAppsToMesh()
replaceme="VARIANT"
def clickAddButton():
    names=name_var.get().split(',')
    for name in names:
        appslistbox.insert(len(appvar.get()),name)

def clickDelButton():
    selected_items = appslistbox.curselection()  
    for selected_item in selected_items[::-1]:
        appslistbox.delete(selected_item)

frame2 =tk.Frame(root)
frame2.pack()
appsLabel= tk.Label(root,text='Enter new appearance variants')
appsLabel.pack(side=tk.TOP)

# creating a entry for input
name_var=tk.StringVar()
name_var.set('name')
name_entry = tk.Entry(frame2,textvariable = name_var)
entryTip = Hovertip(name_entry,'Enter new appearance variants. \n (multiple comma seperated works)')
# creating a label for the entry
entry_label = ttk.Label(frame2, text = 'New Variant')
# Button to add it
add_but=ttk.Button(frame2,text="Add", command=clickAddButton)
myTip1 = Hovertip(add_but,'Add the new variants to the list.')
appvar=tk.Variable(value=appearanceNames)

entry_label.pack(side=tk.LEFT)
name_entry.pack(side=tk.LEFT)
add_but.pack(side=tk.RIGHT)
frame3 =tk.Frame(root)
frame3.pack()
appslistbox = tk.Listbox(
    frame3,
    listvariable=appvar,
    height=6,
    selectmode=tk.EXTENDED
)
appslistbox.pack(side=tk.LEFT,expand=True,fill=tk.BOTH)
scrollbar2 = ttk.Scrollbar(
    frame3,
    orient=tk.VERTICAL,
    command=appslistbox.yview
)
appslistbox['yscrollcommand'] = scrollbar2.set
scrollbar2.pack(side=tk.RIGHT, expand=True, fill=tk.Y)
# Button to del selected items
del_but=ttk.Button(root,text="-", command=clickDelButton)
myTip2 = Hovertip(del_but,'delete the selected variant(s) from the list.')
del_but.pack()


frame4 =tk.Frame(root)
frame4.pack(pady=10)
# creating a entry for input
replaceme_var=tk.StringVar()
replaceme_var.set('VARIANT')
replaceme_entry = tk.Entry(frame4,textvariable = replaceme_var, text=replaceme_var)
entryTip = Hovertip(replaceme_entry,'Text to be used as replacement wildcard')
# creating a label for the entry
replaceme_label = ttk.Label(frame4, text = 'Variant replacement key')
replaceme_label.pack(side=tk.LEFT)
replaceme_entry.pack(side=tk.LEFT)

frame5 =tk.Frame(root)
frame5.pack()
def process_Mesh():    
    root.test.appearanceNames=list(appvar.get())
    root.test.replaceme=replaceme_var.get()
    root.test.aprocess(path,path)

# Save as button
save_button = ttk.Button(
    frame5,
    text='Update Ent File',
    command=process_Mesh

)


def process_new_Mesh():
    saveaspath = fd.asksaveasfilename(initialdir='F:\\CPMod\\Vesna\\source\\raw\\base\\characters\\garment\\e3_content',        filetypes=filetypes)
    root.test.appearanceNames=list(appvar.get())
    root.test.replaceme=replaceme_var.get()
    root.test.aprocess(path,saveaspath)

# Save as button
saveas_button = ttk.Button(
    frame5,
    text='Save As New Ent File',
    command=process_new_Mesh

)


save_button.pack(side=tk.LEFT, expand=True)
saveas_button.pack(side=tk.LEFT,pady=10, expand=True)

root.mainloop()


