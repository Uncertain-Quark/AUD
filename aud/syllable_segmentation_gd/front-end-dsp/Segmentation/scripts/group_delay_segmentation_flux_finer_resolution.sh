#!/bin/tcsh -f

setenv WSF $2

	ch_wave $1 -o results/wav -otype nist

	echo "thresSilence = $3 and thersVoiced = $4"
	echo "wavefile = $1"

front-end-dsp/Segmentation/bin/SegmentationFlux front-end-dsp/Segmentation/src/fe-words_flux_finer_resolution.base $1 results/sigFlux results/specFlux results/boundaryFlux $3  $4 

	cat results/specFlux | awk '{print $7}' > results/gd_spectrumFlux
        cat results/boundaryFlux | awk '{print $5 * 48000}' > results/segmentsFlux
        cat results/boundaryFlux | awk '{print $6}' > results/segmentsFlux_indicator
        cat results/boundaryFlux | cut -d " " -f5- > results/boundaryFlux.lab
        sed -i 's/\ /\ 125\ /' results/boundaryFlux.lab
        sed -i '1,1s/^/#\n/' results/boundaryFlux.lab
        cp results/gd_spectrumFlux results/gd_spectrumFlux.txt
	cat results/spec_low | cut -d " " -f4 > results/flux.txt
