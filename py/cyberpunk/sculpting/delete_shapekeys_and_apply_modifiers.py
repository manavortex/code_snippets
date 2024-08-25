import bpy

def delete_all_shapekeys(obj):
    """Deletes all shapekeys for a given object, iterating backwards."""
    if obj.data.shape_keys:
        # Iterate over the shapekeys in reverse order
        for key_block in reversed(obj.data.shape_keys.key_blocks):
            obj.shape_key_remove(key_block)
        print(f"All shapekeys deleted for object: {obj.name}")
    else:
        print(f"No shapekeys found for object: {obj.name}")

def apply_non_armature_modifiers(obj):
    """Applies all modifiers that are not armature modifiers."""
    for modifier in obj.modifiers:
        if modifier.type != 'ARMATURE':
            bpy.context.view_layer.objects.active = obj
            bpy.ops.object.modifier_apply(modifier=modifier.name)
            print(f"Applied modifier: {modifier.name} on object: {obj.name}")

def main():
    """Main function to process selected objects."""
    # Check for selected mesh objects
    selected_meshes = [obj for obj in bpy.context.selected_objects if obj.type == 'MESH']
    
    if not selected_meshes:
        print("No mesh objects selected.")
        return

    for mesh in selected_meshes:
        print(f"Processing object: {mesh.name}")
        delete_all_shapekeys(mesh)
        apply_non_armature_modifiers(mesh)

if __name__ == "__main__":
    main()
