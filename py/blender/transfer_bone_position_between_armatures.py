import bpy

target_object_name = bpy.context.object.name
source_object_name = None
        
for arm in filter(lambda obj: obj.type == 'ARMATURE' and obj.visible_get(), bpy.data.objects):
    if arm.name != target_object_name:
        source_object_name = arm.name


# Get the source and target armatures
source_armature = bpy.data.objects[source_object_name]
target_armature = bpy.data.objects[target_object_name]

# Get the source and target bones
source_bone = source_armature.pose.bones['Root']
target_bone = target_armature.pose.bones['Root']

# Copy the source bone's position to the target bone
target_bone.matrix = source_bone.matrix

print(source_bone.matrix)
