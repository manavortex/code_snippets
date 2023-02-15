# Import Module
import os
import collections
import yaml
import re
import shutil
  
variants = ['black_gold', 'black_silver']

# Folder Path
path = "E:\\path\\to\\your.yaml"

replaceme = "VARIANT"
################################################### DO NOT EDIT BELOW THIS LINE ########################################################


if not os.path.isfile("{}.orig".format(path)):
    shutil.copy(path, "{}.orig".format(path))
else:
    os.remove(path) 
    shutil.copy("{}.orig".format(path), path)   


def append_constructor(loader: yaml.SafeLoader, node: yaml.nodes.ScalarNode) -> str:
  return f"!append {loader.construct_scalar(node)} append!"

yaml.SafeLoader.add_constructor("!append", append_constructor)

def replace_in_dict(dict, source, target, currentSlotIdx): 
    ret = dict.copy()
    for key in ret.keys():
        value = ret[key]
        if isinstance(value, collections.abc.Mapping):
            ret[key] = replace_in_dict(value, source, target, currentSlotIdx)
        elif isinstance(value, str):
            ret[key] = re.sub(source, target, value)
        elif isinstance(value, list):
            ary = []
            for elem in value: 
                ary.append(elem)
            ret[key] = ary
        else:
            print(type(value))
        if (key == "atlasPartName"):
            ret[key] = re.sub("\d\d", str(currentSlotIdx).zfill(2), value)

    return ret


# Read YAML file
with open(path, 'r') as stream:
    text_content = yaml.safe_load(stream)
    items = text_content.copy().items()

    highestSlotIndex = 0
    for _key, _value in items:
        # get highest atlas slot
        if not ("icon" in _value and "atlasPartName" in _value["icon"]):
                continue
        atlasNameSlot = _value["icon"]["atlasPartName"]
        
        print("atlasNameSlot is " + str(atlasNameSlot))
        if atlasNameSlot is not None:
            slotNo = int(''.join(filter(str.isdigit, atlasNameSlot)))
            slotNo = 0 if slotNo is None else int(slotNo)
            print("slotNo is " + str(slotNo))
            if slotNo > highestSlotIndex:
                highestSlotIndex = slotNo

    newVariants = {}

    for _key, _value in items:
        if not "VARIANT" in _key: 
            continue; 

        for appearanceName in variants: 
            key = _key.replace(replaceme, appearanceName)
            value = replace_in_dict(_value, replaceme, appearanceName, highestSlotIndex)
            highestSlotIndex += 1

            text_content[key] = value


    with open("_output.yml", "w") as yaml_file:                    
        yaml.dump(text_content, yaml_file)
               

# tidy up borked yaml tags. PYTHON WHY
with open("_output.yml", 'r') as file :
    filedata = file.read()

    # Replace the target string
    filedata = filedata.replace("- '!append", '  - !append')
    filedata = filedata.replace(" append!'", '')

    # Write the file out again
    with open('file.yml', 'w') as file:
        file.write(filedata)
            
