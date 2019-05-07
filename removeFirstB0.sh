#!/bin/bash

dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`

mkdir outDWI

# split dwi images on t axis
echo "fslsplit"
fslsplit ${dwi} dwi_split -t

# remove first b0
echo "remove first b0"
rm -rf dwi_split0000.nii.gz

# merge remaining images into new dwi file
echo "fslmerge"
fslmerge -t ./outDWI/dwi.nii.gz *dwi_split*

# remove first b0 from bvals
echo "fix bvals"
cut -d " " -f 2- ${bvals} > ./outDWI/dwi.bvals

# copy proper bvecs
cp -v dwi.bvecs ./outDWI/

# remove unneccesary files
echo "remove split files"
rm -rf *dwi_split*

if [ -f ./outDWI/dwi.nii.gz ];
then
	echo 0 > finished
else
	echo "output missing"
	echo 1 > finished
fi
