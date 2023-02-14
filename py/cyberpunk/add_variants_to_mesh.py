import json
import os
import copy
import shutil

path = "E:\\path\\to\\your\\mesh\\your_mesh.mesh.json"

appearanceNames = ['black', 'white', 'neon_blue', 'neon_green']


replaceme="VARIANT"


t=None
appearances=None
materials=None
matEntries = None


def processMaterial(appearanceName, mat):
    for value in mat['values']:
        if "MultilayerSetup" in value and 'DepotPath' in value['MultilayerSetup']:
            value['MultilayerSetup']['DepotPath']=value['MultilayerSetup']['DepotPath'].replace(replaceme, appearanceName)
        if "MultilayerMask" in value and 'DepotPath' in value['MultilayerMask']:
            value['MultilayerMask']['DepotPath']=value['MultilayerMask']['DepotPath'].replace(replaceme, appearanceName)
        if "GlobalNormal" in value and 'DepotPath' in value['GlobalNormal']:
            value['GlobalNormal']['DepotPath']=value['GlobalNormal']['DepotPath'].replace(replaceme, appearanceName)
        if "BaseColor" in value and 'DepotPath' in value['BaseColor']:
            value['BaseColor']['DepotPath']=value['BaseColor']['DepotPath'].replace(replaceme, appearanceName)
        if "Normal" in value and 'DepotPath' in value['Normal']:
            value['Normal']['DepotPath']=value['Normal']['DepotPath'].replace(replaceme, appearanceName)
    return mat


def addAppearance(appearanceName):
    appearances.append(copy.deepcopy(t['appearances'][0]))
    app=appearances[len(appearances)-1]
    app['Data']['name']=app['Data']['name'].replace('__variant', appearanceName)
    if app['Data']['name']=="default":
        app['Data']['name'] = appearanceName
    app['HandleId']=str(len(appearances)-1)
    a=0
    while a < len(app['Data']['chunkMaterials']):
        app['Data']['chunkMaterials'][a]=app['Data']['chunkMaterials'][a].replace(replaceme, appearanceName)
        a+=1
    a=0
    while a < len(app['Data']['tags']):
        app['Data']['tags'][a]=app['Data']['tags'][a].replace(replaceme, appearanceName)
        a+=1

    t['renderResourceBlob']['HandleId']=str(len(appearances))
   
def addMaterialName(appearanceName):
    matEntries.append(copy.deepcopy(matEntries[0]))
    matEnt=matEntries[len(matEntries)-1]
    matEnt['name']=matEnt['name'].replace(replaceme, appearanceName)
    matEnt['index']=len(matEntries)-1

def addMaterial(appearanceName):
    materials.append(copy.deepcopy(materials[0]))
    mat=materials[len(materials)-1]
    processMaterial(appearanceName, mat)
    
if not os.path.isfile("{}.orig".format(path)):
    shutil.copy(path, "{}.orig".format(path))
else:
    os.remove(path) 
    shutil.copy("{}.orig".format(path), path)

with open(path,'r') as f: 
    j=json.load(f)

    t=j['Data']['RootChunk']
    appearances=t['appearances']
    materials=t['localMaterialBuffer']['materials']
    matEntries = t['materialEntries']

    for appearanceName in appearanceNames:
        addAppearance(appearanceName)
        addMaterialName(appearanceName)
        addMaterial(appearanceName)
             
'''
  
 
    for override in app['Data']['partsOverrides']:
        for compOverride in override['componentsOverrides']:
            compOverride['meshAppearance'] = appearanceName

'''



with open(path, 'w') as outfile:
    json.dump(j, outfile,indent=2)
