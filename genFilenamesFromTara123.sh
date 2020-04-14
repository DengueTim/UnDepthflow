#!/bin/bash
# To be run in a Sequence dir with *_L.png and *_R.png files.

THIS_DIR=`basename $(pwd)`
DIR_RELATIVE_TO_DATASET_ROOT=${1:-$THIS_DIR}

imgs=()
for i in `ls -v *.png` ; do
	imgs+=($i)
done

noImgs=${#imgs[@]}
endIndex=$((noImgs-7))

for (( i=0 ; i<=${endIndex} ; i++ )) ;do
	if [[ "${imgs[$i]}" == *L.png ]]; then
		iMod3=$(( i % 6))
		if (( $iMod3 == 0 )); then
			# 1 frames apart
			echo "$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+1))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i+2]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+3))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/calib_cam_to_cam.txt"
		elif (( $iMod3 == 2 )); then
			# 2 frames apart
			echo "$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+1))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i+4]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+5))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/calib_cam_to_cam.txt"
		elif (( $iMod3 == 4 )) ; then
			# 3 frames apart
			echo "$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+1))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$i+6]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/${imgs[$((i+7))]}" \
				"$DIR_RELATIVE_TO_DATASET_ROOT/calib_cam_to_cam.txt"
		fi
	fi
done
