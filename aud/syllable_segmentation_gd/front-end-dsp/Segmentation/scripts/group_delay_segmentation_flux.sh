#!/bin/tcsh -f

setenv WSF $2

	ch_wave $1 -o results/wav -otype nist

	echo "thresSilence = $3 and thersVoiced = $4"
	echo "thresFlux = $5"
	echo "wavefile = $1"
        set wavname=`echo $1 | rev | cut -d "/" -f1 | rev | cut -d "." -f1`
        set sigFlux=$wavname."sigFlux"
        set specFlux=$wavname."specFlux"
        set boundaryFlux=$wavname."boundaryFlux"
        
front-end-dsp/Segmentation/bin/SegmentationFlux front-end-dsp/Segmentation/src/fe-words_flux.base $1 results/$sigFlux results/$specFlux results/$boundaryFlux $3 $4 $5

	cat results/$specFlux | awk '{print $7}' > results/$wavname."gd_spectrumFlux"
	cat results/$specFlux | awk '{print $11}' > results/$wavname."fluxSmth.txt"
	cat results/$specFlux | awk '{print $6}' > results/$wavname."magnitudeSpectrumFlux.txt"
	cat results/$specFlux | awk '{print $2}' > results/$wavname."sig.txt"
        cat results/$boundaryFlux | awk '{print $5 * 48000}' > results/$wavname."segmentsFlux"
        cat results/$boundaryFlux | awk '{print $6}' > results/$wavname."segmentsFlux_indicator"
        cat results/$boundaryFlux | cut -d " " -f5- > results/$wavname."boundaryFlux.lab"
        sed -i 's/\ /\ 125\ /' results/$wavname."boundaryFlux.lab"
        sed -i '1,1s/^/#\n/' results/$wavname."boundaryFlux.lab"
        cp results/$wavname."gd_spectrumFlux" results/$wavname."gd_spectrumFlux.txt"
	cat results/$wavname."specFlux" | cut -d " " -f4 > results/$wavname."flux.txt"
