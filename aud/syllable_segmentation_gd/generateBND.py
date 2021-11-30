# Generate BND file given an input and destination folder
import os
import sys

inputpath=sys.argv[1]
destfolder=sys.argv[2]

folder=inputpath.rstrip('/').split('/')[-2]
destpath = destfolder + '/' + folder + '/' + inputpath.rstrip('/').split('/')[-1].split('.')[0] + '.bnd'
ctrlfile = '../seg.ctrl'

print(destpath)
print('mkdir -p {}/{}'.format(destfolder,folder))
os.system('mkdir -p {}/{}'.format(destfolder,folder))
print( './bin/SyllableBoundaries {} {} {} 200 100 0.5 0.2'.format(ctrlfile,inputpath,destpath) )
os.system('./bin/SyllableBoundaries {} {} {} 200 100 0.5 0.2'.format(ctrlfile,inputpath,destpath))

