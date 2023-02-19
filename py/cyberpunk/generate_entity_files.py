import json
import os


path = "E:\\path\\to\\your.ent.json"

appearanceNames=['purple', 'blue', 'green', 'red', 'orange', 'yellow']

with open(path,'r') as f: 
    j=json.load(f)   
        
    t=j['Data']['RootChunk']
    comps=t['components']
    for app in appearanceNames:
        for c in comps:
            if 'meshAppearance' in c.keys():
                c['meshAppearance']=app
        
        filename = path.split('\\')[-1]
        basename = filename.split('.')[0]

        outname=filename.replace('.', "_{}.".format(app), 1)
        pathout=os.path.join(os.path.dirname(path),outname )
        with open(pathout, 'w') as outfile:
            json.dump(j, outfile,indent=2)

