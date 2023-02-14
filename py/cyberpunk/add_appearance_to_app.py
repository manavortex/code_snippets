import json
import os
import re
import copy
import shutil

path = "E:\\path\\to\\appearance.app.json"

appearanceNames=['black_gold', 'black_silver']

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
                compOverride['meshAppearance'] = appearanceName
                compOverrides.append(compOverride)
            override['componentsOverrides'] = compOverrides
            overrides.append(override)

        app['Data']['partsOverrides'] = overrides

        t['appearances'].append(app)
        i += 1



with open(path, 'w') as outfile:
    json.dump(j, outfile,indent=2)
