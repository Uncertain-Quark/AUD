import sys

filepath=sys.argv[1]
destpath=sys.argv[2]

with open(filepath,'r') as f :
    lines = f.readlines()

array = lines[0].strip().split(' ')
destlines = []

print('Number of lines : {}'.format(len(array)/5))

i=0
while i < len(array) :
    destlines.append('{} {} {} {} {}\n'.format(array[i],array[i+1],array[i+2],array[i+3],array[i+4]))
    i+=5

with open(destpath,'w') as f:
    f.writelines(destlines)

