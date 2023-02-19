import json
import os
import re
import copy
import shutil
# gui imports
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog as fd
from tkinter import messagebox
from idlelib.tooltip import Hovertip

root = tk.Tk()
root.title('App file updater')
root.resizable(True, True)
root.geometry('400x600')
root.j={}
filetypes = (
        ('json files', '*.app.json'),
        ('All files', '*.*')
    )
path = fd.askopenfilename(initialdir='E:\\Downloads\\',        filetypes=filetypes)

appearanceNames=["white", "black", "red", "pink", "navy", "green"]
appvar=tk.Variable(value=appearanceNames)
baselist=['ff_pants','ff_shirt','ff_belt']

blacklist=['ff_shoes']
blklst_var=tk.Variable(value=blacklist)
with open(path,'r') as f: 
    root.j=json.load(f)

root.t=root.j['Data']['RootChunk']
root.appearances=root.t['appearances']

root.existing_apps=[]
for __app in root.appearances:
    root.existing_apps.append(__app['Data']['name'])
var = tk.Variable(value=root.existing_apps)
frame =tk.Frame(root)

baseLabel= ttk.Label(root, text='Select base appearances to duplicate')
baseLabel.pack(side=tk.TOP)
frame.pack(pady=5,padx=5,)
listbox = tk.Listbox(
    frame,
    listvariable=var,
    height=6,
    selectmode=tk.EXTENDED
)
listbox.pack(side=tk.LEFT,expand=True,fill=tk.BOTH, ipadx=0)
entryTip = Hovertip(listbox,'Select the base apps to generate variants from. \n Select multiple with ctrl. \n if none are selected the top one in the list is used')
scrollbar = ttk.Scrollbar(
    frame,
    orient=tk.VERTICAL,
    command=listbox.yview
)
listbox['yscrollcommand'] = scrollbar.set
scrollbar.pack(side=tk.RIGHT, expand=True, fill=tk.Y, ipadx=0)

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

# 
#
#

def clickblAddButton():
    names=blname_var.get().split(',')
    for name in names:
        bllistbox.insert(tk.END,name)

def clickblDelButton():
    selected_items =bllistbox.curselection()  
    for selected_item in selected_items[::-1]:
        bllistbox.delete(selected_item)

frame4 =tk.Frame(root)
frame4.pack()
blLabel= tk.Label(root,text='Enter any meshAppearances to NOT change')
blLabel.pack(side=tk.TOP)

# creating a entry for input
blname_var=tk.StringVar()
blname_var.set('name')
blname_entry = tk.Entry(frame4,textvariable = blname_var)
entryTip = Hovertip(blname_entry,'Enter meshAppearance to blacklist. \n (multiple comma seperated works)')
# creating a label for the entry
blentry_label = ttk.Label(frame4, text = 'New Blacklist entry')
# Button to add it
bladd_but=ttk.Button(frame4,text="Add", command=clickblAddButton)
myTip3 = Hovertip(bladd_but,'Add the new variants to the list.')

blentry_label.pack(side=tk.LEFT)
blname_entry.pack(side=tk.LEFT)
bladd_but.pack(side=tk.RIGHT)
frame5 =tk.Frame(root)
frame5.pack()
bllistbox = tk.Listbox(
    frame5,
    listvariable=blklst_var,
    height=6,
    selectmode=tk.EXTENDED
)
bllistbox.pack(side=tk.LEFT,expand=True,fill=tk.BOTH)
scrollbar3 = ttk.Scrollbar(
    frame5,
    orient=tk.VERTICAL,
    command=bllistbox.yview
)
bllistbox['yscrollcommand'] = scrollbar3.set
scrollbar3.pack(side=tk.RIGHT, expand=True, fill=tk.Y)
# Button to del selected items
bldel_but=ttk.Button(root,text="-", command=clickblDelButton)
myTip4 = Hovertip(bldel_but,'delete the selected variant(s) from the list.')
bldel_but.pack()

name_entry.focus_set()

root.update()


def process_app(outpath=path):
    appearanceNames=[]
    appearanceNames=list(appvar.get())
    print(appearanceNames)
    baselist=[]
    saved_sel=[]
    for ind in listbox.curselection():
        baselist.append(listbox.get(ind))
        saved_sel.append(ind)
    if len(baselist)<1:
        messagebox.showerror(title='Error!', message='You need to select at least 1 base appearance.')
    else:
        print(baselist)
        blacklist=list(blklst_var.get())

        if not os.path.isfile("{}.orig".format(path)):
            shutil.copy(path, "{}.orig".format(path))
        #else:
        #    os.remove(path) 
         #   shutil.copy("{}.orig".format(path), path)

    


        i = 0
        for appearanceName in appearanceNames:
            for _app in root.appearances:    
                if (_app['Data']['name'] in baselist):
                    original =  copy.deepcopy(_app)        
                    newname=_app['Data']['name']+'_'+appearanceName
                    if newname not in root.existing_apps:
                        print(appearanceName)
                        app =  copy.deepcopy(original)
                        app['Data']['name'] =  newname
                
                        for i,override in enumerate(app['Data']['partsOverrides']):
                    
                            for compOverride in override['componentsOverrides']:                
                                if compOverride['meshAppearance'] not in blacklist: 
                                    compOverride['meshAppearance'] = appearanceName


                        root.t['appearances'].append(app)
                        i += 1



        with open(outpath, 'w') as outfile:
            json.dump(root.j, outfile,indent=2)

        with open(outpath,'r') as f: 
            lines=f.readlines()

        ii=0
        jj=0
        for x,line in enumerate(lines):
            if 'HandleId' in line:
                lines[x]=line[:line.find('"HandleId": "')+len('"HandleId": "')]+str(ii)+line[-3:]
                ii+=1
            if 'BufferId' in line:
                eol=-3
                if line[eol]!='"':
                    eol=-2
                lines[x]=line[:line.find('"BufferId": "')+len('"BufferId": "')]+str(jj)+line[eol:]
                jj+=1
            if '"components": null,' in line:
                lines[x]=line.replace('"components": null,', '"components": [],')

        with open(outpath, 'w') as outfile:
            outfile.writelines(lines)

        with open(outpath,'r') as f: 
            root.j=json.load(f)
        root.t=root.j['Data']['RootChunk']
        root.appearances=root.t['appearances']

        root.existing_apps=[]
        for __app in root.appearances:
            root.existing_apps.append(__app['Data']['name'])
        listbox.delete(0, tk.END)
        for __app in root.existing_apps:
            listbox.insert(tk.END,__app)
        print(saved_sel)
        for item in saved_sel:
            listbox.selection_set(item)
        messagebox.showinfo(title='Export Complete', message='The Variants have been added.')

# Update button
open_button = ttk.Button(
    root,
    text='Update Input App File',
    command=process_app

)

def process_new_app():
    saveaspath = fd.asksaveasfilename(initialdir='F:\\CPMod\\Vesna\\source\\raw\\base\\characters\\garment\\e3_content',        filetypes=filetypes)
    process_app(saveaspath)

# Save as button
saveas_button = ttk.Button(
    root,
    text='Save As New App File',
    command=process_new_app

)
open_button.pack(side=tk.LEFT,pady=10, expand=True)
saveas_button.pack(side=tk.LEFT,pady=10, expand=True)

root.mainloop()
