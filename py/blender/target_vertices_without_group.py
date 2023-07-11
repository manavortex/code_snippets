import bpy

# If you set this to "True", the script will DELETE vertices without groups. Otherwise, it'll select them for you in edit mode. 
AUTO_DELETE = False

############################################### change below this line at own risk ###############################################

for obj in bpy.context.selected_objects:
    if not obj.type == 'MESH':
        continue
    
    vertices = []
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='DESELECT')
    bpy.ops.object.mode_set(mode='OBJECT')
    for v in bpy.context.object.data.vertices:
     v.select = not v.groups
     if not v.groups:
        vertices.append(v)
    
    if not vertices:
        print("No vertices without group found in {}".format(obj.name))
        continue
    
    
    print("Found {} vertices without group in {}".format(len(vertices), obj.name))
    print(vertices)
        
    bpy.ops.object.mode_set(mode='EDIT')
    if AUTO_DELETE:
        print("Deleting them for you...")
        bpy.ops.mesh.delete(type='VERT')    
    else:
        print("Deleting them for you...")
        print(vertices)
        break
