#!/bin/bash
# To be run in a Sequence dir with *_L.png and *_R.png files.

THIS_DIR=`basename $(pwd)`
DIR_RELATIVE_TO_DATASET_ROOT=${1:-$THIS_DIR}

unset i j k l

for i in `ls *.png` ; do
	if [[ "$l" == *L.png ]]; then
		echo "$DIR_RELATIVE_TO_DATASET_ROOT/$l" \
			"$DIR_RELATIVE_TO_DATASET_ROOT/$k" \
			"$DIR_RELATIVE_TO_DATASET_ROOT/$j" \
			"$DIR_RELATIVE_TO_DATASET_ROOT/$i" \
			"$DIR_RELATIVE_TO_DATASET_ROOT/calib_cam_to_cam.txt"
	fi
	l=$k
	k=$j
	j=$i
done
