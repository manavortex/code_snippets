# Import Module
import os
import collections
import yaml
import re
  
variants = ['variant_1', 'variant_2']

# Run in same folder as a yaml file with one entry. VARIANT will be substituted for variant name in values and in top level key.
# ATTENTION: Doesn't work for nested arrays. Use flat arrays with key: \n  - item

path = os.path.dirname(__file__)

def replace_in_dict(dict, source, target, slotNumber): 
    ret = dict.copy()
    for key in ret.keys():
        value = ret[key]
        if isinstance(value, collections.abc.Mapping):
            ret[key] = replace_in_dict(value, source, target, slotNumber)
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
            ret[key] = re.sub("00", str(slotNumber).zfill(2), value)                

    return ret


# iterate through all file
for file in os.listdir():
    # Check whether file is in text format or not
    if file.endswith(".yaml"):
        file_path = f"{path}\{file}"    

        key = ""
        value = None

        # Read YAML file
        with open(file_path, 'r') as stream:
            text_content = yaml.safe_load(stream)

            for _key, _value in text_content.items():
                if "VARIANT" in _key:
                    key = _key
                    value = _value

            idx = 1
            for appearanceName in variants: 
                _key = re.sub("VARIANT", appearanceName, key)
                _value = replace_in_dict(value, "VARIANT", appearanceName, idx)
                idx += 1

                text_content[_key] = _value
            
            print(yaml.dump(text_content))

            del text_content[key]

            with open("test.yml", "w") as yaml_file:
               yaml.dump(text_content, yaml_file)
