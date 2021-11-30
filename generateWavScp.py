# Generate Wav.scp files given an input folder with various speakers and a destination
import os,sys,glob

inputpath=sys.argv[1]
destpath=sys.argv[2]

inputwavfiles = glob.glob(inputpath+'/*/*.wav')
wavscp = []

for f in inputwavfiles:
    recordingID = f.rstrip('/').split('/')[-2] + '-' + f.rstrip('/').split('/')[-1].split('.')[0]
    line = '{} {}\n'.format(recordingID,f)
    print(line)
    wavscp.append(line)

with open(destpath + '/wav.scp','w') as f :
    f.writelines(wavscp)

