# Code to produce the .bnd files from .wav files

# Input:
#  Root Folder
#  |
#  |--- Spk1
#  |--- Spk2
#  |--- Spk3
#  Root folder is passed as an argument
#  Pass the Destination folder as another argument

InputFolder=$1
DestinationFolder=$2

for f in $InputFolder/*/*.wav;do
	# Extract the .bnd files
	echo $f
	python3 generateBND.py $f $DestinationFolder
done

