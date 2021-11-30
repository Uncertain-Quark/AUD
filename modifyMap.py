import sys

filepath=sys.argv[1]
destpath=sys.argv[2]

with open(filepath,'r') as f:
    lines = f.readlines()

destlines = []

for l in lines:
    lineNum=l.split()[0]
    subject = l.strip().split()[1].split('/')[-1].split('.')[0]
    destlines.append( '{} {}\n'.format(lineNum,subject) )

with open(destpath,'w') as f:
    f.writelines(destlines)
