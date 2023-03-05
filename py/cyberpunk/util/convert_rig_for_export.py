import os
import bpy
import re

isNoesis = False

def getMeshNames():
    meshNames = []
    for mesh in filter(lambda obj: obj.type == 'MESH', bpy.data.objects):
        meshNames.append(mesh.name)
        
    return sorted(meshNames)

def renameMeshes():
    index = 0
    for meshName in getMeshNames():
        mesh =  bpy.data.objects[meshName]
        if not mesh.visible_get():
            continue;
        
        formatString =  "submesh{}" if isNoesis else "submesh_{}_LOD_1"
        meshIdx = str(index) 
        if not isNoesis:
            meshIdx = meshIdx.zfill(2)
        
        mesh.name = formatString.format(meshIdx)        
        index += 1
        
def rotateArmatures():  
  for armature in filter(lambda obj: obj.type == 'ARMATURE', bpy.data.objects):
      if not armature.visible_get():
          continue;
      # to change the name, simply do "armature.name = xyz"
      rotation = armature.rotation_quaternion
      if (isNoesis):
          armature.rotation_quaternion.w = 0.0
          armature.rotation_quaternion.z = -1.0
      else:
          armature.rotation_quaternion.w = 1.0
          armature.rotation_quaternion.z = 0.0      

    
renameMeshes()
rotateArmatures()

bpy.context.window.workspace = bpy.data.workspaces["Layout"]
