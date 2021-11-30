# COde to remove parantthesis 

import sys

filename=sys.argv[1]
destfile=sys.argv[2]

with open(filename,'r') as f:
    lines=f.read()

lines = lines.replace('[','')
lines = lines.replace(']','')

with open(destfile,'w') as f:
    f.write(lines)
