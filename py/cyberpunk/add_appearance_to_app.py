import json
import os
import re
import copy
import shutil

path = "E:\\path\\to\\your.app.json"

appearanceNames=["white", "black", "red", "pink", "navy", "green"]

# appearances to duplicate
baselist=['ff_shirt','ff_pants','ff_belt']

# components to ignore
blacklist=['belt_buckle_component']

if not os.path.isfile("{}.orig".format(path)):
    shutil.copy(path, "{}.orig".format(path))
#else:
#    os.remove(path) 
 #   shutil.copy("{}.orig".format(path), path)

with open(path,'r') as f: 
    j=json.load(f)

t=j['Data']['RootChunk']
appearances=t['appearances']

existing_apps=[]
for __app in appearances:
    existing_apps.append(__app['Data']['name'])


i = 0
for appearanceName in appearanceNames:
    for _app in appearances:    
        if (_app['Data']['name'] in baselist):
            original =  copy.deepcopy(_app)        
            newname=_app['Data']['name']+'_'+appearanceName
            if newname not in existing_apps:
                print(appearanceName)
                app =  copy.deepcopy(original)
                app['Data']['name'] =  newname
                
                for i,override in enumerate(app['Data']['partsOverrides']):
                    
                    for compOverride in override['componentsOverrides']:                
                        if compOverride['meshAppearance'] not in blacklist: 
                            compOverride['meshAppearance'] = appearanceName


                t['appearances'].append(app)
                i += 1



with open(path, 'w') as outfile:
    json.dump(j, outfile,indent=2)

with open(path,'r') as f: 
    lines=f.readlines()

i=0
j=0
for x,line in enumerate(lines):
    if 'HandleId' in line:
        lines[x]=line[:line.find('"HandleId": "')+len('"HandleId": "')]+str(i)+line[-3:]
        i+=1
    if 'BufferId' in line:
        eol=-3
        if line[eol]!='"':
            eol=-2
        lines[x]=line[:line.find('"BufferId": "')+len('"BufferId": "')]+str(j)+line[eol:]
        j+=1
    if '"components": null,' in line:
        lines[x]=line.replace('"components": null,', '"components": [],')

with open(path, 'w') as outfile:
    outfile.writelines(lines)

