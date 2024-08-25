import bpy

def add_shrinkwrap_modifier(obj):
    """Adds a Shrinkwrap modifier with specific settings to the given object."""
    # Check if the object already has a shrinkwrap modifier named "Garment Support"
    if "Garment Support" in [mod.name for mod in obj.modifiers]:
        print(f"Object '{obj.name}' already has a 'Garment Support' modifier. Skipping...")
        return

    # Add the Shrinkwrap modifier
    shrinkwrap_mod = obj.modifiers.new(name="GarmentSupport", type='SHRINKWRAP')

    # Set the Shrinkwrap modifier properties
    shrinkwrap_mod.wrap_method = 'NEAREST_SURFACEPOINT'  # Nearest Surface Point method
    shrinkwrap_mod.wrap_mode = 'OUTSIDE_SURFACE'         # Above Surface mode
    shrinkwrap_mod.offset = 0.0005                       # Set the offset

    print(f"Added 'Garment Support' Shrinkwrap modifier to '{obj.name}'.")

def main():
    """Main function to add Shrinkwrap modifier to all selected objects."""
    # Get all selected mesh objects
    selected_meshes = [obj for obj in bpy.context.selected_objects if obj.type == 'MESH']

    if not selected_meshes:
        print("No mesh objects selected.")
        return

    for mesh in selected_meshes:
        add_shrinkwrap_modifier(mesh)

if __name__ == "__main__":
    main()
