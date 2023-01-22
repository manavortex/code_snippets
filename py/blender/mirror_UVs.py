import bpy

uvOffset = {    
    'armature_1_name': {
        '1': 0.6
    },  
    'armature_2_name': {
        '0': 0.0022
    }    
}


def uvMirrorY(mesh):
    # get number for name checking
    meshNumberMatch = re.sub('^submesh_0|^submesh', '', mesh.name)
    meshNumberMatch = re.sub('(?<=\d)_.+$', '', meshNumberMatch)
    
    meshUniqueID = "{}.{}".format(mesh.parent.name, meshNumberMatch)  
    
    wasFlipped = meshUniqueID in bpy.context.scene.keys()

    print("mirroring UVs {} (was already flipped: {}, should be flipped: {})".format(mesh.name, wasFlipped, not isNoesisExport))
    
    # don't flip twice
    if (wasFlipped == (not isNoesisExport)):
        return    
    
    #+ grab the current area
    original_area = bpy.context.area.type

    view_layer = bpy.context.view_layer
    
    view_layer.objects.active = mesh
    #+ switch to the UV editor to perform transforms etc
    bpy.context.area.ui_type = 'UV'
    bpy.ops.object.mode_set(mode='EDIT', toggle=False)

    bpy.ops.mesh.reveal()
    bpy.ops.mesh.select_all(action='SELECT')
    #+ select the uvs
    bpy.ops.uv.select_all(action='SELECT')

    bpy.ops.transform.mirror(constraint_axis=(False, True, False))
    
    if (mesh.parent.name in uvOffset.keys()):
        meshOffsets = uvOffset[mesh.parent.name]
        meshNumberMatch = re.sub('^submesh_0|^submesh', '', mesh.name)
        meshNumberMatch = re.sub('(?<=\d)_.+$', '', meshNumberMatch)
        offset = 0.0 if not meshNumberMatch in meshOffsets.keys() else meshOffsets[meshNumberMatch]
        if isNoesisExport:
            offset = offset * -1
        if offset != 0:
            print("{}.submesh{} needs offset: {}".format(mesh.parent.name, meshNumberMatch, offset))    
            bpy.ops.transform.transform(value=(0.0, offset, 0.0, 0.0))

    bpy.context.scene[meshUniqueID] = True
    #+ return to the original mode where the script was run
    bpy.context.area.type = original_area
    bpy.ops.object.mode_set(mode='OBJECT', toggle=False)
