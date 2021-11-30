import sys

featLST=sys.argv[1]

targetLines = []

with open(featLST,'r') as f:
    lines = f.readlines()

length = len(lines)

for i,l in enumerate(lines):
    outfile = 'OUTDIR/{}'.format(l.split('/')[-1].split('.')[0]+'.out')
    line = './DTW {} {} {} {}\n'.format(featLST,length,i,outfile)
    targetLines.append(line)

with open('r.sh','w') as f:
    f.writelines(targetLines)
