import json
import os
import re
import copy
import shutil

path = "E:\\Path\\to\\root_entity.ent.json"

appearanceNames=["white", "black", "red", "pink", "navy", "green"]

replaceme="VARIANT"


################################################### DO NOT EDIT BELOW THIS LINE ########################################################

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
    for appearanceName in appearanceNames:
        app =  copy.deepcopy(original)

        app['appearanceName']                   = app['appearanceName'].replace(replaceme, appearanceName)
        app['name']                             = app['name'].replace(replaceme, appearanceName)
        app['appearanceResource']['DepotPath']  = app['appearanceResource']['DepotPath'].replace(replaceme, appearanceName)
        t['appearances'].append(app)

with open(path, 'w') as outfile:
    json.dump(j, outfile,indent=2)
