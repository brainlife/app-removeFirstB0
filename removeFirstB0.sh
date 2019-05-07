#!/bin/bash

dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`

# split dwi images on t axis
echo "fslsplit"
fslsplit ${dwi} dwi_split -t

# remove first b0
echo "remove first b0"
rm -rf dwi_split0000.nii.gz

# merge remaining images into new dwi file
echo "fslmerge"
fslmerge -t dwi.nii.gz *dwi_split*

# remove first b0 from bvals
echo "fix bvals"
cut -d " " -f 2- ${bvals} > dwi.bvals

# remove unneccesary files
echo "remove split files"
rm -rf *dwi_split*

if [ -f dwi.nii.gz ];
then
	echo 0 > finished
else
	echo "output missing"
	echo 1 > finished
fi
