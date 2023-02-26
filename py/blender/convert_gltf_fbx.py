import bpy
import re

# False: Adjust rotation and submesh names for gltf
# True:  Adjust rotation and submesh names for fbx
useFbx = False

for armature in filter(lambda obj: obj.type == 'ARMATURE', bpy.data.objects):
    if (ignoreHiddenObjects and not armature.is_visible):
        continue;
    # to change the name, simply do "armature.name = xyz"
    rotation = armature.rotation_quaternion
    if (useFbx):
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
    if (useFbx):
        mesh.name = "submesh{}".format(meshNumberMatch)
    else:
        mesh.name = "submesh_{}_LOD_1".format(meshNumberMatch.zfill(2)) # prefix with leading zero
