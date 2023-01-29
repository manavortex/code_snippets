import bpy
import re
from bpy import context as C
import numpy as np

def transferUVmaps(source, o):
    uvs = np.empty((2 * len(source.data.uv_layers[0].data), 1), "f")

    print("transfering uvs from " + source.name + " to " + o.name)
    target_layers = o.data.uv_layers
    while target_layers:
        o.data.uv_layers.remove(o.data.uv_layers[0])
    for l in source.data.uv_layers:
        l.data.foreach_get('uv', uvs)
        target_layer = target_layers.new(name=l.name, do_init=False)
        target_layer.data.foreach_set('uv', uvs)
        target_layer.active_clone = l.active_clone
        target_layer.active_render = l.active_render
        target_layer.active = l.active



for morphArmature in filter(lambda obj: obj.type == 'ARMATURE' and "__morphs" in obj.name, bpy.data.objects):

    uvArmatureName=re.sub('__morphs', '_c__basehead', morphArmature.name)

    uvArmature = bpy.context.scene.objects.get(uvArmatureName) 
    
    print(morphArmature)    
    print(uvArmature)
    
    armatureMeshes = list(filter(lambda obj: obj.type == 'MESH' and  obj.parent == morphArmature, bpy.data.objects))
    uvMeshes = list(filter(lambda obj: obj.type == 'MESH' and  obj.parent == uvArmature, bpy.data.objects))
    
    if len((armatureMeshes)) != len((uvMeshes)):
        print("Error finding UV meshes for " + uvArmatureName)
        continue
    
    print("\n" + uvArmatureName)
    for mesh in armatureMeshes:
        name = re.sub('\.\d+$', '', mesh.name)
        for uvMesh in filter(lambda m: m.name.startswith(name), uvMeshes):
            transferUVmaps(uvMesh, mesh)
        
        
