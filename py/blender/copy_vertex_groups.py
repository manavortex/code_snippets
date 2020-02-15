import bpy

source = bpy.data.objects['OLD']
target = bpy.data.objects['NEW']
for group in source.vertex_groups:
    vg = target.vertex_groups.new(name=group.name)
