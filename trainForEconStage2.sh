#!/bin/bash

#	--retrain=True --pretrained_model=./outForEconStage1/best/model-195003 \

python main.py --data_dir=../datasets/kitti/ \
	--batch_size=4 --mode=depth --train_test=train \
	--retrain=False --pretrained_model=./outForEconStage2/model-215003 \
	--train_file=./filenames/kitti_train_files_png_4framesBW.txt \
	--gt_2012_dir=../datasets/kitti/gt_stereo_2012/training \
	--gt_2015_dir=../datasets/kitti/gt_scene_2015/training \
	--trace=outForEconStage2 \
	--grey_scale=True --img_height=320 --img_width=704

