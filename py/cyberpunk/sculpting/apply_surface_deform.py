import bpy

# Define the target mesh name at the top of the script
TARGET_MESH_NAME = "target_mesh_name"  # Replace with the actual name of your target mesh

def add_surface_deform_modifier(obj, target_mesh_name):
    """Adds a surface deform modifier to the given object targeting the specified mesh."""
    # Create a new Surface Deform modifier
    modifier = obj.modifiers.new(name="SurfaceDeform", type='SURFACE_DEFORM')
    
    # Set the target of the Surface Deform modifier
    modifier.target = bpy.data.objects.get(target_mesh_name)
    
    if modifier.target is None:
        print(f"Warning: Target mesh '{target_mesh_name}' not found for object '{obj.name}'")
    else:
        print(f"Added Surface Deform modifier to '{obj.name}' targeting '{target_mesh_name}'")

def main():
    # Get the target mesh object
    target_mesh = bpy.data.objects.get(TARGET_MESH_NAME)
    
    if target_mesh is None:
        print(f"Error: Target mesh '{TARGET_MESH_NAME}' not found.")
        return
    
    # Iterate over all selected mesh objects
    for obj in bpy.context.selected_objects:
        if obj.type == 'MESH':
            add_surface_deform_modifier(obj, TARGET_MESH_NAME)
        else:
            print(f"Skipping '{obj.name}' as it is not a mesh object.")

if __name__ == "__main__":
    main()
