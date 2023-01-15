import bpy
import re

# Script to adjust armature rotation and submesh names for glb or fbx export

# False: Adjust rotation and submesh names for export via glb
# True:  Adjust rotation and submesh names for export via fbx
isNoesisExport = False

# True: Ignore hidden objects (meshes/armatures) when renaming/rotating
ignoreHiddenObjects = False


for armature in filter(lambda obj: obj.type == 'ARMATURE', bpy.data.objects):
    if (ignoreHiddenObjects and not armature.is_visible):
        continue;
    # to change the name, set "armature.name = xyz"
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
    meshNumberMatch = re.sub('^submesh_0|^submesh', '', mesh.name)
    meshNumberMatch = re.sub('(?<=\d)_.+$', '', meshNumberMatch)
    print(meshNumberMatch)
    if (isNoesisExport):
        mesh.name = "submesh{}".format(meshNumberMatch)
    else:
        mesh.name = "submesh_{}_LOD_1".format(meshNumberMatch.zfill(2)) # prefix with leading zero
        
    
