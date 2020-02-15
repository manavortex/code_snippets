# https://blender.stackexchange.com/a/1880/88475
def dump(obj):
    print("\n%s \"%s\"" % (obj.name, obj.type ))
    print(obj.name)
    for attr in dir(obj):
       if hasattr( obj, attr ) and "name" != attr:
           attrVal = getattr(obj, attr)
           if attrVal:
               print( "obj.%s = %s" % (attr, attrVal))
