import bpy

# If you set this to "True", unassigned vertices will be deleted.
# Right now, you will be taken to edit mode with the unassigned vertices selected.
AUTO_DELETE = False

############################################### change below this line at own risk ###############################################

c = {}
for area in bpy.context.screen.areas:
    if area.type == 'CONSOLE':
        c['area'] = area
        c['region'] = area.regions[-1]
        c['space_data'] = area.spaces.active
        c['screen'] = bpy.context.screen
        c['window'] = bpy.context.window

def to_console(str):
    bpy.ops.console.scrollback_append(c, text = str)

def find_unmatched_vertex_groups(mesh, armature):
    unmatched_groups = []
    
    for group in mesh.vertex_groups:
        if group.name not in armature.data.bones:
            unmatched_groups.append(group.name)
    
    return unmatched_groups

def find_armature_for_mesh(mesh):
    # Check direct parent relationship
    if mesh.parent and mesh.parent.type == 'ARMATURE':
        return mesh.parent

    # Check Armature modifier targets
    for modifier in mesh.modifiers:
        if modifier.type == 'ARMATURE' and modifier.object:
            return modifier.object
    
    return None    

for obj in bpy.context.selected_objects:
    if not obj.type == 'MESH':
        continue
    
    meshParent = find_armature_for_mesh(obj)
    if meshParent == None:
         to_console("Mesh {} doesn't seem to have a parent armature!".format(obj.name))
    else:
        unmatched_groups = find_unmatched_vertex_groups(obj, meshParent)
        if unmatched_groups:
            to_console("Vertex groups from mesh missing in parent armature: [ {} ]"
                .format( ", ".join(unmatched_groups)))
        
    
    vertices = []
    bpy.ops.object.mode_set(mode='EDIT')
    bpy.ops.mesh.select_all(action='DESELECT')
    bpy.ops.object.mode_set(mode='OBJECT')
    for v in bpy.context.object.data.vertices:
     v.select = not v.groups
     if not v.groups:
        vertices.append(v)
    
    if not vertices:
        to_console("All vertices in {} have a group!".format(obj.name))
        continue
    
    
    to_console("Found {} vertices without group in {}".format(len(vertices), obj.name))
    to_console(vertices)
        
    bpy.ops.object.mode_set(mode='EDIT')
    if AUTO_DELETE:
        to_console("Deleting them for you...")
        bpy.ops.mesh.delete(type='VERT')    
