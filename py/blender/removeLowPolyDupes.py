import bpy
scene = bpy.context.scene

def delete_object(name):
    bpy.ops.object.select_all(action='DESELECT')
    # https://wiki.blender.org/wiki/Reference/Release_Notes/2.80/Python_API/Scene_and_Object_API
    bpy.data.objects[name].select_set(True) # Blender 2.8x
    bpy.ops.object.delete() 


def clean_objects(skeleton):
    keepMesh = "none"
    meshName = ""
    polyCount = 0
    meshMap = {}
    for child in skeleton.children:
        if not  "MESH" == child.type: 
            continue; 
        dotIndex = child.name.find(".")
        
        tmpName = child.name[:dotIndex] if dotIndex > 0 else child.name

        if not tmpName in meshMap.keys(): 
            meshMap[tmpName] = {}
        meshMap[tmpName][len(child.data.polygons)] = child.name
    for meshName, meshData in meshMap.items():
        first = True
        for key, value in sorted(meshData.items(), reverse = True):
            if first: 
                first = False
                continue
            delete_object(value)


root_obs = (o for o in scene.objects if not o.parent)


for o in root_obs:
    print(o.type)
    if "Skeleton" in o.name: 
        clean_objects(o)
    if "EMPTY" == o.type and len(o.children) == 0:
        delete_object(o.name)
