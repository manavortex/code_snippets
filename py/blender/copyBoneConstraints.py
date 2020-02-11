import bpy

copyFrom = "Left"
copyTo = "Right"

pBones = [ b for b in bpy.context.object.pose.bones if copyFrom in b.name ]
print(pBones)
for b in pBones:
    for c in b.constraints:
        
        otherBone = bpy.context.object.pose.bones[ 
            b.name.replace( copyFrom, copyTo ) 
        ]

        nc = otherBone.constraints.new( c.type )

        for prop in dir( c ):
            # This is fairly ugly and dirty, but quick and does the trick...
            try:
                constrProp = getattr( c, prop )
                if type( constrProp ) == type(str()) and (copyFrom in constrProp or copyTo in constProp)
                    # Replace string property values from L to R and vice versa
                    oppositeVal = constrProp.replace(copyFrom, copyTo) if copyFrom in constrProp else constrProp.replace(copyTo, copyFrom)
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
