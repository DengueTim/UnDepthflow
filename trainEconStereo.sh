#!/bin/bash

#	--retrain=True \

python main.py --data_dir=../datasets/EconTara/ \
	--batch_size=4 --mode=stereo --train_test=train \
       	--retrain=False --pretrained_model=./outEconStereo/model-205003 \
       	--train_file=../datasets/EconTara/Econ_080420_09xxxx_8bit.txt \
	--gt_2012_dir=../datasets/kitti/gt_stereo_2012/training \
	--gt_2015_dir=../datasets/kitti/gt_scene_2015/training \
	--trace=outEconStereo --num_gpus=2 --learning_rate=0.00001 \
	--grey_scale=True --img_height=320 --img_width=704
