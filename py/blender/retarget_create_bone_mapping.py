# generates entries for a config file for Animation Retargeting plugin


import bpy
print('\n\n\n\n\n\n\n\n')

bpy.ops.object.mode_set(mode="OBJECT")
for ob in bpy.data.objects:
    if ob.type == "ARMATURE":
        for bone in ob.data.bones:
            print('{')
            print('  "source": "%s",' %(bone.name))
            print('  "target": "%s",' %(bone.name))
            print('  "rest": [ 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 ],')
            print('  "offset": [ 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0 ]')
            print('},')
