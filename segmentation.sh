# Code to produce the .bnd files from .wav files

# Input:
#  Root Folder
#  |
#  |--- Spk1
#  |--- Spk2
#  |--- Spk3
#  Root folder is passed as an argument
#  Pass the Destination folder as another argument

# Sourcing Kaldi Path
source path.sh

InputFolder=$1
DestinationFolder=$2
KaldiDestination=./kaldiFiles/
ROOT=./aud/

# Generating wav.scp
python3 generateWavScp.py $InputFolder $KaldiDestination

for f in $InputFolder/*/*.wav;do
	# Extract the .bnd files
	echo $f
	python3 generateBND.py $f $DestinationFolder $ROOT
done

# Generating the segments all file
ls $DestinationFolder/*/*.bnd |parallel -k "awk -v file={1} '{printf \"%s %3.2f %3.2f\n\",file,(\$1)/200,(\$2)/200}' {1}" |awk '{printf "file_%05d %s \n",NR,$0}' > segments_all
#awk '{if($4-$3 > 0.1){print $0}}' segments_all > segments

# Generating utt2spk and segments file
python3 generateSegmentsUtt2spk.py segments_all $KaldiDestination


# Generating feat files
compute-mfcc-feats --verbose=2 --config=conf/mfcc.conf scp,p:$KaldiDestination/wav.scp ark:- | copy-feats --compress=true ark:- ark,scp:mfccDir/train.ark,mfccDir/train.scp
compute-cmvn-stats scp:mfccDir/train.scp ark,scp:mfccDir/cmvn_train.ark,mfccDir/cmvn_train.scp

# Generating segments from feat files
extract-feature-segments --frame-length=25 --frame-shift=10 --min-segment-length=0.075 scp:mfccDir/train.scp ./kaldiFiles/segments ark,scp:mfccDir/feats.ark,mfccDir/feats.scp

apply-cmvn --utt2spk=ark:$KaldiDestination/utt2spk scp:./mfccDir/cmvn_train.scp scp:mfccDir/feats.scp ark:- | add-deltas  ark:- ark,t:mfccDir/feats.txt

#########################################################################################

# Generate the Clusters
awk '{if(NF==2){print prevname" "NR-1" "NR-prevno-1;prevno=NR;prevname=$1}}' ./mfccDir/feats.txt > $KaldiDestination/temp.txt
# remove paranthesis
python3 removeParan.py ./mfccDir/feats.txt ./mfccDir/featsTemp.txt

less $KaldiDestination/temp.txt |parallel -k --colsep ' ' "head -{2} ./mfccDir/featsTemp.txt |tail -{3} > featsDir/{1}.mfc"

ls featsDir/*.mfc |parallel -k "awk 'NR==FNR{sum++;next;}{if(FNR==1){print \"39 \"sum};print \$0}' {1} {1} > {1.}.mfcc"

ls ./featsDir/*.mfcc > ./tempDir/feat.lst
python3 makeR.py ./tempDir/feat.lst

less r.sh |parallel -k -j 16
echo "head -n1 OUTDIR/file_00001.out | grep -o " " | wc -l"
less ./tempDir/feat.lst |parallel -k "less OUTDIR/{1/.}.out" > ./tempDir/mat.txt

lines=$(sed -n '$=' ./tempDir/mat.txt)
seq 1 $lines |parallel -k "awk -v n={1} 'NR==n{print \$0;exit}' ./tempDir/mat.txt |tr ' ' '\n' |awk '{print \$1\" \"NR}' |sort -nk1 |awk '{print \$2}' |head -5|tr '\n' ' '" > ./tempDir/tempDel1.txt
seq 1 $lines |parallel -k "python -c \"print('{1} ' * 5)\"" > ./tempDir/tempDel2.txt

awk '{print NR" "$1}' ./tempDir/feat.lst > ./tempDir/map.txt


matlab -r scc("tempDel1_reshaped.txt","tempDel2.txt","cluster_3.txt")
awk 'NF > 4' cluster_3.txt > cluster_3_4.txt

# Code to generate map modify to remove paths and extensions from map.txt
python3 mapModify.py tempDir/map.txt tempDir/mapModify.txt

#less ../tempDir/mapModify.txt |parallel -k -j1 --colsep ' ' "sed -i 's/ {1} / {2} /' cluster_3_4_mapped.txt"
python3 ./clusterDir/convert.py ./clusterDir/cluster_3_4.txt ./clusterDir/cluster_3_4_mapped.txt

############### Complete with Stage 3 : Clustering of snippets #####################
# to remove whitespaces at the end
sed -i 's/ $//' cluster_3_4_mapped.txt

############### Stage 4 : Main Expt #####################


