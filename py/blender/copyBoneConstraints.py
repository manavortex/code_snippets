import bpy

# based on https://blender.stackexchange.com/a/40246

copyFrom = "Left"
copyTo = "Right"

pBones = [ b for b in bpy.context.object.pose.bones if copyFrom in b.name and 0 < len(b.constraints) ]

for b in pBones:
    otherBone = bpy.context.object.pose.bones[  b.name.replace( copyFrom, copyTo ) ]
    print("")
    print( b.name +  " -> " + str(otherBone))
    for c in b.constraints:         
        print("")
        nc = otherBone.constraints.new( c.type ) 
        for prop in dir( c ):   
            # This is fairly ugly and dirty, but quick and does the trick...
            try:
                constrProp = getattr( c, prop )
                print(str(prop) + " -> " + str(constrProp))
                if type( constrProp ) == type(str()) and ("Left" in constrProp or "Right" in constrProp):
                    oppositeVal = constrProp.replace("Left", "Right") if "Left" in constrProp else constrProp.replace("Right", "Left")                     
                    print(" -> " + str(constrProp) + " -> " + str(oppositeVal))
                    setattr( nc, prop, oppositeVal ) 
                elif 'max_' in prop:
                    setattr( nc, prop, getattr( c, prop.replace( 'max', 'min' ) ) )
                elif 'min_' in prop:
                    setattr( nc, prop, getattr( c, prop.replace( 'min', 'max' ) ) )
                elif prop == 'influence':
                    # Influence 0 becomes 1 and 1 becomes 0
                    setattr( nc, prop, abs( constrProp - 1 ) )
                elif type( constrProp ) in [ type( float() ), type( int() ) ]:
                    # Invert float and int values ( mult by -1 )
                    setattr( nc, prop, constrProp * -1 )
                else:
                    # Copy all other values as they are
                    setattr( nc, prop, constrProp )
            except:
                pass
