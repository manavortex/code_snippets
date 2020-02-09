
import bpy 

skeletonName = "Skeleton"
grps_and_partials = {

    'loincloth':    {"layerNo": 8, "colorSet":"THEME01", "partials": ["Loincloth", "Cloth"] }, 
    'hair':         {"layerNo": 4, "colorSet":"THEME02", "partials": ["Hair"]}, 
    'face':         {"layerNo": 5, "colorSet":"THEME03", "partials": ["Eye", "Lip", "Jaw", "Mouth", "Cheek", "Tongue", "Chin", "Nose", "Brow"]},    
    'stuff':        {"layerNo": 32, "colorSet":"THEME04", "partials": ["Prop", "Trajectory"] },
    
    'hair':         {"layerNo": 7, "colorSet":"THEME05", "partials": ["Hair"], "colorSet":"THEME04" }, 
    'torso':        {"layerNo": 1, "colorSet":"THEME06", "partials": ["Trajyectory", "Hips", "Spine", "Pelvis", "Neck", "Head", "Breast"]}, 
    'arms':         {"layerNo": 2, "colorSet":"THEME07", "partials": ["Shoulder", "Arm"]}, 
    'legs':         {"layerNo": 2, "colorSet":"THEME08", "partials": ["Leg", "Foot", "Toe"]}, 
    'hands':        {"layerNo": 3, "colorSet":"THEME09", "partials": ["Hand"]}, 
    
    'weapons':      {"layerNo": 31, "colorSet":"THEME10", "partials": ["Trail", "Spawn", "Connect"] }
}



armature = bpy.data.armatures[skeletonName]
pose = bpy.context.active_object.pose
 
poseBones = bpy.context.active_object.pose.bones
editBones = armature.edit_bones

if 0 == len(editBones): 
    print("Please select the green armature thingy, not the yellow one")
    exit



class GetBoneGroup:    
    global getBoneGroup 
    global getEnum
    global printList
    
    def getEnum(n): 
        return EnumProperty(name=n)
        
    
    def getBoneGroup(n):
        
        grps = pose.bone_groups
        for elem in grps: 
            if n == elem.name:
                return elem 

        return grps.new(name=n)
    
    def printList(l):
        return ', '.join([str(elem) for elem in l])
        

# print(bpy.context.active_object)
 
# print("\n\n")
# print(poseBones)
# print("\n")
# print(editBones)
# print("\n\n") 

namesAndBones = {}
noneMatches = []


for grpName in grps_and_partials: 

    grpProps = grps_and_partials[grpName]
    layerNo = grpProps.get("layerNo")
    namePartials = grpProps.get("partials")
    print("Assigning to group %s by name partials [ %s ]" % (grpName, printList(namePartials))) 
    boneGroup = getBoneGroup(grpName)
    boneGroup.color_set = grpProps.get("colorSet")
    namesAndBones[grpName] = [];
    for partial in namePartials:
        for bone in editBones:
            if partial in bone.name: 
                namesAndBones[grpName].append(bone.name)
                bone.layers = [False]*32
                bone.layers[layerNo-1] = True
                poseBones[bone.name].bone_group = boneGroup
            else:
                noneMatches.append(bone.name)


print("\n\n\n")
for grpName in namesAndBones: 
    boneNames = ""
    for boneName in namesAndBones[grpName]:
        if boneName in noneMatches: 
            noneMatches.remove(boneName)
        boneNames = boneNames + boneName + ", "
    
    print("%s : [ %s ] " % (grpName, boneNames))
    print("\n\n")
print("\n\n\n")
print(noneMatches)
