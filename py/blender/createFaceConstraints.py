import bpy

armature = bpy.data.objects["Skeleton"]

bpy.ops.object.mode_set(mode="POSE")

print("\nAutomatically setting up bone constraints to mirror location and rotation\n")
bones = bpy.context.selected_pose_bones if bpy.context.selected_pose_bones else bpy.context.object.pose.bones
L = "Left"
R = "Right"
 
# if more bones are selected with names containing L: copy from left to right, otherwise: right to left
copyFrom = L if sum(L in bone.name for bone in bones) > sum(R in bone.name for bone in bones) else R
copyTo = R if L == copyFrom else L

for b in [ b for b in bones if copyFrom in b.name ]:
    otherBone = bpy.context.object.pose.bones[ b.name.replace( copyFrom, copyTo ) ]    
    print(b.name + " -> " + otherBone.name)

    # Get all constraints targetting current bone, make sure we don't have dupes
    constraintsTargetingCurrentBone = [ c for c in otherBone.constraints if c.subtarget == b.name]


    for c in constraintsTargetingCurrentBone:
        if c.type == 'COPY_ROTATION' or c.type == "COPY_LOCATION" :
            otherBone.constraints.remove( c ) # Remove constraint       
    
     

    print( "setting up constraints to hook %s to %s (rotation, location)" % (otherBone.name, b.name)    )
    nc = otherBone.constraints.new( "COPY_ROTATION" )
    nc.invert_x = True
    nc.invert_y = True
    nc.target_space = "LOCAL"
    nc.owner_space  = nc.target_space
    nc.target = armature
    nc.subtarget = b.name
    nc.use_x = True
    nc.use_y = True
    nc.use_z = True
    
    nc = otherBone.constraints.new( "COPY_LOCATION" ) 
    nc.target_space = "LOCAL"
    nc.owner_space  = nc.target_space
    nc.target = armature
    nc.subtarget = b.name
    nc.use_x = True
    nc.use_y = True
    nc.use_z = True
