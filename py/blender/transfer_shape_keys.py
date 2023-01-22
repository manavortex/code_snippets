import bpy
import re

def getMeshIndex(mesh):    
    meshNumberMatch = re.sub('^submesh_0|^submesh', '', mesh.name)
    return re.sub('(?<=\d)_.+$', '', meshNumberMatch)

# if armatures are selected: get objects inside armature
def addSubmeshesToList(obj, list):
    for mesh in filter(lambda o: o.type == 'MESH' and o.parent.name == obj.name, bpy.data.objects):
        list.append(mesh)        
    return list

def deleteShapekeyByName(oObject, shapekeyName):
    
    # setting the active shapekey
    iIndex = oObject.data.shape_keys.key_blocks.keys().index(shapekeyName)
    oObject.active_shape_key_index = iIndex
    
    # delete it
    bpy.ops.object.shape_key_remove(apply_mix=True)



def collectMeshesWithShapekeys():
    meshesToProcess = []
    
    # if nothing is selected: apply to all meshes
    if (not bpy.context.selected_objects == []):
        for object in bpy.context.selected_objects:
            addSubmeshesToList(object, meshesToProcess)
            return meshesToProcess

    for mesh in filter(lambda obj: 
        obj.type == 'MESH' 
        and obj.data.shape_keys is not None
        and len(obj.data.shape_keys.key_blocks) > 2
        , bpy.data.objects):
        meshesToProcess.append(mesh)

    return meshesToProcess


def copy_all_shape_keys(source, target):        
    bpy.ops.object.select_all(action='DESELECT')
    target.select_set(True)
    bpy.context.view_layer.objects.active = target
    
    if target.data.shape_keys is not None:
        for shapekey in target.data.shape_keys.key_blocks:        
            deleteShapekeyByName(target, shapekey.name)
            
    bpy.context.view_layer.objects.active = source
    print("copying shapekeys: \n\t\t{}.{}\n\t\t=>\n\t\t{}.{}".format(source.parent.name, source.name, target.parent.name, target.name))
    
    
    for idx in range(1, len(source.data.shape_keys.key_blocks)):
        source.active_shape_key_index = idx        
        target.shape_key_add(name=source.active_shape_key.name)
        bpy.ops.object.shape_key_transfer()
        
        

for targetArmature in filter(lambda o: o.type == 'ARMATURE' and o.name.endswith('copyme_suffix'), bpy.data.objects):
    sourceArmatureName = re.sub('\.glb\.?\d*', '', targetArmature.name)
    sourceArmature = bpy.data.objects[sourceArmatureName]
    if sourceArmature is None:
        print("couldn't find armature {}".format(sourceArmatureName))
        continue
    
    print("copying shapekeys {} => {}".format(sourceArmature.name, targetArmature.name))
    
    sourceMeshes = addSubmeshesToList(sourceArmature, [])
    targetMeshes = addSubmeshesToList(targetArmature, [])
    
    for source in sourceMeshes:
        meshIndex = getMeshIndex(source)
        for target in filter(lambda m: getMeshIndex(m) == meshIndex, targetMeshes):
            copy_all_shape_keys(source, target)
