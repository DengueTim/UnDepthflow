#!/bin/bash

#	--retrain=True --pretrained_model=./outForEconStage1/best/model-195003 \
#	--retrain=True --pretrained_model=./outEconStage1/best/model-240002 \

python main.py --data_dir=../datasets/ \
	--batch_size=4 --mode=depth --train_test=train \
	--retrain=False --pretrained_model=./outEconStage2/model-10002 \
       	--train_file=../datasets/kitti_train_files_png_4framesBW.txt \
	--gt_2012_dir=../datasets/kitti/gt_stereo_2012/training \
	--gt_2015_dir=../datasets/kitti/gt_scene_2015/training \
	--trace=outEconStage2 --num_gpus=2 \
	--grey_scale=True --img_height=320 --img_width=704

