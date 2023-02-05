import bpy
import re

# highest resolution: 0, second highest: 1, and so on
index = 1
vertexThreshold = 40000

meshes = {}

for mesh in filter(lambda obj: obj.type == 'MESH', bpy.data.objects):
    groupName = re.sub('\.\d+$', '', mesh.name)
    if not groupName in meshes:
        meshes[groupName] = []
    meshes[groupName].append(mesh.name)


for key in meshes:
    submeshes = []
    meshNames = meshes[key]
    for meshName in meshNames:
        mesh =  bpy.data.objects[meshName]
        submeshes.append(mesh)

    meshes[key] = sorted(submeshes, key=lambda x: len(x.data.vertices), reverse=True)
    

selectedNames = []
deleteNames = []    

for key in meshes:
    i = 0
    for submesh in meshes[key]:
        numVertices = len(submesh.data.vertices)
        groupName = re.sub('\.\d+$', '', mesh.name)        
        
        # either the index matches
        shouldSelect = i == index 
        
        # if the index matches, but the vertex count is too high, don't keep it
        shouldSelect = shouldSelect and (vertexThreshold == 0 or numVertices <= vertexThreshold)
                        
        if (not shouldSelect and i > index and vertexThreshold > 0):
            shouldSelect = any(s.startswith(groupName) for s in selectedNames)
            
        # if there's only one submesh, don't delete
        shouldSelect = shouldSelect or len(meshes[key]) === 1   
        
        (selectedNames if (shouldSelect or justOneMesh) else deleteNames).append(submesh.name)
        
        i += 1

print("Deleting all but {}".format(selectedNames))

bpy.ops.object.select_all(action='DESELECT')
for deleteName in deleteNames:
    bpy.data.objects[deleteName].select_set(True)
    bpy.ops.object.delete()
