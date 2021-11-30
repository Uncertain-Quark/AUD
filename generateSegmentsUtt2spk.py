# Code to generate Segments and Utt2spk files
import os,sys

Segmentspath=sys.argv[1]
destpath = sys.argv[2]

with open(Segmentspath,'r') as f:
    lines=f.readlines()

segmentsInter,utt2spjInter=[],[]
segments,utt2spk=[],[]

for i in lines:
    splitLines = i.strip().split(' ')
    ID = splitLines[-3].split('/')[-2] + '-' + splitLines[-3].split('/')[-1].split('.')[0]
    print(ID)
    print(splitLines)
    newsplitLines = splitLines.copy()
    newsplitLines[-3] = ID
    #print(newsplitLines)
    segments.append(''.join(j + ' ' for j in newsplitLines))
    print(''.join(j + ' ' for j in newsplitLines))
    utt2spk.append(''.join(j + ' ' for j in newsplitLines[:2]))
    print(''.join(j + ' ' for j in newsplitLines[:2]))

segments = [k + '\n' for k in segments]
utt2spk = [k + '\n' for k in utt2spk]

with open(destpath + '/segments','w') as f:
    f.writelines(segments)
with open(destpath + '/utt2spk','w') as f:
    f.writelines(utt2spk)






