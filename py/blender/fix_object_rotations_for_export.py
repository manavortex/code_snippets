import bpy
import re

# False: Adjust rotation and submesh names for export via WolvenKit
# True:  Adjust rotation and submesh names for export via Noesis
isNoesisExport = False

# True: Ignore hidden objects (meshes/armatures) when renaming/rotating
ignoreHiddenObjects = False

numberToBodyPart = {
    '1': 'eyes',
    '2': 'nose', 
    '3': 'mouth', 
    '4': 'jaw', 
    '5': 'ears',
}

def getTargetComponentName(shapekeyName):
    try:
        partIndex = shapekeyName[3] # determined by third number in string, e.g. 'h011'
        return numberToBodyPart[partIndex]
    except:
        return 0

for armature in filter(lambda obj: obj.type == 'ARMATURE', bpy.data.objects):
    if (ignoreHiddenObjects and not armature.is_visible):
        continue;
    # to change the name, simply do "armature.name = xyz"
    rotation = armature.rotation_quaternion
    if (isNoesisExport):
        armature.rotation_quaternion.w = 0.0
        armature.rotation_quaternion.z = -1.0
    else:
        armature.rotation_quaternion.w = 1.0
        armature.rotation_quaternion.z = 0.0      
   
    
for mesh in filter(lambda obj: obj.type == 'MESH' and re.match("^submesh_0|^submesh", obj.name), bpy.data.objects):
    if (ignoreHiddenObjects and not mesh.is_visible):
        continue;
    
    
    # rename them as expected by import algo
    try:         
        meshNumberMatch = re.search('[0-9]+', mesh.name).group()
        print(meshNumberMatch)
        if (isNoesisExport):
            mesh.name = "submesh{}".format(re.sub('^0', '', str(meshNumberMatch)))
        else:
            mesh.name = "submesh_{}_LOD_1".format(meshNumberMatch.zfill(2)) # prefix with leading zero
    except:
        print("couldn't find a numeric index for {}".format(mesh.name))
    
    # adjust shapekey names
    if mesh.data.shape_keys is None: 
        continue;
    
    for shapekey in mesh.data.shape_keys.key_blocks:
        partName = getTargetComponentName(shapekey.name)
        if 0 != partName and not shapekey.name.endswith('_' + partName):
            shapekey.name = shapekey.name + '_' + partName
        
        # get rid of anything weird
        shapekey.name = re.sub('_+', '_', shapekey.name)
        shapekey.name = re.sub('_ear_ears+', '_ears', shapekey.name)
    
