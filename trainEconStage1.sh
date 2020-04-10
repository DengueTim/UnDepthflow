#!/bin/bash

python main.py --data_dir=../datasets/ \
	--batch_size=4 --mode=flow --train_test=train \
	--retrain=False --pretrained_model=./outForEconStage1/best/model-195003 \
       	--train_file=../datasets/KittiEconTrainingFilenames.txt \
	--gt_2012_dir=../datasets/kitti/gt_stereo_2012/training \
	--gt_2015_dir=../datasets/kitti/gt_scene_2015/training \
	--trace=outEconStage1 --num_gpus=2 --learning_rate=0.00001 \
	--grey_scale=True --img_height=320 --img_width=704

