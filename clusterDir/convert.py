# Code to convert cluster_3_4.txt using mapModify.txt to cluster_3_4_mapped.txt

import sys

mapfile = sys.argv[1]
clusterfiles = sys.argv[2]
destfile = sys.argv[3]

with open(mapfile,"r") as f:
    maplines = f.readlines()

mapdict = {}
for line in maplines:
    mapdict[line.strip().split()[0]] = line.strip().split()[1]
    print(line.strip().split()[0],line.strip().split()[1])
#[ mapdict[line.strip().split()[0]] = mapdict[line.strip().split()[1]] for line in maplines ]

with open(clusterfiles,"r") as f:
    clusterlines = f.readlines()

destlines = []

for line in clusterlines:
    words = line.strip().split()
    destline = [ mapdict[w] for w in words ]
    destlines.append( " ".join(destline) + "\n")

with open(destfile,"w") as f:
    f.writelines(destlines)


