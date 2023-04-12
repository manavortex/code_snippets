import bpy
active_object = bpy.context.active_object

vertex_groups = active_object.vertex_groups[:]

for vertex_group in vertex_groups:
    if vertex_group.name.startswith('r_'):
        vertex_group.name = vertex_group.name.replace('r_', 'l_', 1)
        continue
    if vertex_group.name.startswith('l_'):
        vertex_group.name = vertex_group.name.replace('l_', 'r_', 1)
        continue
    if vertex_group.name.startswith('Left'):
        vertex_group.name = vertex_group.name.replace('Left', 'Right', 1)
        continue
    if vertex_group.name.startswith('Right'):
        vertex_group.name = vertex_group.name.replace('Right', 'Left', 1)
        continue
