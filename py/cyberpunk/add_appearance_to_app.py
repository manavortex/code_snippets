import json
import os
import re
import copy
import shutil

path = "F:\\path\\to\\your.app.json"

appearanceNames=["white", "black", "red", "pink", "navy", "green"]

replaceme="VARIANT"


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
    if (not replaceme in _app['Data']['name']):
        _app['HandleId'] = str(i)
        _app['Data']['compiledData']["BufferId"] = str(i)
        i += 1
        continue
    original =  copy.deepcopy(_app)
    for appearanceName in appearanceNames:
        app =  copy.deepcopy(original)
        app['HandleId'] = str(i)
        app['Data']['compiledData']["BufferId"] = str(i)

        app['Data']['name'] = re.sub(replaceme, appearanceName, app['Data']['name'])

        overrides = []
        for override in app['Data']['partsOverrides']:
            compOverrides = []
            for compOverride in override['componentsOverrides']:                
                if not replaceme in compOverride['meshAppearance']: 
                    compOverride['meshAppearance'] = appearanceName
                else: 
                    compOverride['meshAppearance'] = compOverride['meshAppearance'].replace(replaceme, appearanceName)
                compOverrides.append(compOverride)
            override['componentsOverrides'] = compOverrides
            overrides.append(override)

        app['Data']['partsOverrides'] = overrides

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


with open(path, 'w') as outfile:
    outfile.writelines(lines)

