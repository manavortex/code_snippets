import json
import os
import re
import copy

# precondition: have appearances set up for the number of variants that you want.
# the script will rename them and fix up the indices, it can't create them yet.

entpath = "E:\\path_to_mesh\\my.mesh.json"

path =  os.path.dirname(entpath)
appearanceNames=['variant_1', 'variant_2']

with open(entpath,'r') as f: 
    j=json.load(f)
   

t=j['Data']['RootChunk']
appearances=t['appearances']

def cleanupValue(value):
    if "MultilayerSetup" in value and 'DepotPath' in value['MultilayerSetup']:
        value['MultilayerSetup']['DepotPath'] = re.sub("VARIANT", appearanceName, value['MultilayerSetup']['DepotPath'])
    if "MultilayerMask" in value and 'DepotPath' in value['MultilayerMask']:
        value['MultilayerMask']['DepotPath'] = re.sub("VARIANT", appearanceName, value['MultilayerMask']['DepotPath'])
    if "GlobalNormal" in value and 'DepotPath' in value['GlobalNormal']:
        value['GlobalNormal']['DepotPath'] = re.sub("VARIANT", appearanceName, value['GlobalNormal']['DepotPath'])
    if "BaseColor" in value and 'DepotPath' in value['BaseColor']:
        value['BaseColor']['DepotPath'] = re.sub("VARIANT", appearanceName, value['BaseColor']['DepotPath'])
    if "Normal" in value and 'DepotPath' in value['Normal']:
        value['Normal']['DepotPath'] = re.sub("VARIANT", appearanceName, value['Normal']['DepotPath'])
    return value

i = 0

for appearanceName in appearanceNames:
    try:
        app = appearances[i]
        app['Data']['name'] = re.sub("VARIANT", appearanceName, app['Data']['name'])

        chunkMaterials = []
        for chunkMaterial in app['Data']['chunkMaterials']:
            chunkMaterials.append(re.sub("VARIANT",appearanceName, chunkMaterial))

        app['Data']['chunkMaterials'] = chunkMaterials
    except:
        print("failed to process appearance {} ({})".format(i, appearanceName))

    localMaterials = t['localMaterialBuffer']['materials']
    refMaterial = localMaterials[0]

    try:
        _localMaterial = localMaterials[i]        
        values = []

        for value in (_localMaterial['values'] if len(_localMaterial['values']) > 0 else refMaterial['values']):
           values.append(cleanupValue(value))

        _localMaterial['values'] = values
    except:
        print("failed to process material {} ({})".format(i, appearanceName))


    try:
        materialEntries = t['materialEntries']
        refMaterial = materialEntries[i]

        materialName = re.sub("VARIANT", appearanceName, refMaterial["name"])
        refMaterial['index'] = i
        refMaterial['name'] = materialName    
    except:        
        print("failed to process materialEntry {} ({})".format(i, appearanceName))

    i += 1    


print("\n\n\n")
print("\n\n\n")
filename = entpath.split("\\")[-1]

print(filename)
path = re.sub(filename, '', entpath)

outname= "{}_edited.mesh.json".format(re.sub('.mesh.json', '', filename))

pathout=os.path.join(path,outname )

with open(pathout, 'w') as outfile:
    json.dump(j, outfile,indent=2)
