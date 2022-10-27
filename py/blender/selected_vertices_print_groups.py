import bpy
import bmesh


obj=bpy.context.object
bm=bmesh.from_edit_mesh(obj.data)


if not obj.mode == 'EDIT':    
    print("Object is not in edit mode.")
else:
    obj=bpy.context.active_object
    selected_verts = list(filter(lambda v: v.select, bm.verts))

    print("\n\n=============== groups of currently selected vertices ===================")

    for group in obj.vertex_groups:
        group_name = group.name
        group_name_printed = False

        for vert in selected_verts:
            i=vert.index
            try:
                weight = obj.vertex_groups[group_name].weight(i)
                #if we get past this line, then the vertex is present in the group
                if (weight > 0) and not group_name_printed: 
                    group_name_printed = True
                    print(group.name)
            except RuntimeError:
               # vertex is not in the group
               pass
