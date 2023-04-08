# script that prepares a hierarchy as downloaded directly from sketchfab for import via Wolvenkit.
# How to use: 
# 1. Switch to Blender "Scripting" perspective
# 2. Create new empty file 
# 3. Paste contents of script in there
# 4. Hit play button
# 5. Profit

import os
import bpy
import re

# Should the meshes be renamed for noesis export? 
isNoesis = False

# Is this a sketchfab export?
flattenHierarchy = True

# apply transformations (before reexport)?
applyTransformations = True
         
# apply transformations only if boolean flag is set      
def applyTransformations(ob):
    mb = ob.matrix_basis
    if hasattr(ob.data, "transform"):
        ob.data.transform(mb)
    for c in ob.children:
        c.matrix_local = mb @ c.matrix_local
        
    ob.matrix_basis.identity()
    
def applyTransformationsAndRename(meshNames):
    index = 0    
    for meshName in meshNames:
        mesh =  bpy.data.objects[meshName]
        if not mesh.visible_get():
            continue;        
        
        if applyTransformations: 
            applyTransformations(mesh)
        
        formatString =  "submesh{}" if isNoesis else "submesh_{}_LOD_1"
        meshIdx = str(index) 
        if not isNoesis:
            meshIdx = meshIdx.zfill(2)
        
        mesh.name = formatString.format(meshIdx)
        index += 1

# remove sketchfab nesting - we want everything flat at root level
if flattenHierarchy:
        
    # clear parents, keep transforms
    for ob in bpy.data.objects:
        bpy.ops.object.select_all(action="DESELECT")
        ob.select_set(state=True)
        bpy.ops.object.parent_clear(type='CLEAR_KEEP_TRANSFORM')

    # delete empties
    [bpy.data.objects.remove(e) for e in [e for e in bpy.data.objects if e.type.startswith('EMPTY') and not e.children]]
 
# collect mesh names for iterating
meshNames = sorted([mesh.name for mesh in filter(lambda obj: obj.type == 'MESH', bpy.data.objects)])

applyTransformationsAndRename(meshNames)

bpy.context.window.workspace = bpy.data.workspaces["Layout"]
