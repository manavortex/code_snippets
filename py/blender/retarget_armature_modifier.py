# script that retargets all visible meshes with armature modifiers to your currently selected armature

import bpy
    
# will only be used if you have nothing selected
targetName = "Armature.002"

if targetName in bpy.data.objects:
    target = bpy.data.objects[targetName]

for obj in bpy.context.selected_objects:
    target = bpy.data.objects[obj.name]
    
if target is None:
    raise TypeError('No armature found. Please select the new parent armature or set its name in line 4 of the script.')

meshNames = sorted([mesh.name for mesh in filter(lambda obj: 
    obj.type == 'MESH' 
    and 'Armature' in obj.modifiers
    and obj.visible_get()
    , bpy.data.objects)])

for name in meshNames: 
    obj = bpy.data.objects[name]
    if 'Armature' in obj.modifiers:         
        obj.modifiers['Armature'].object=target
