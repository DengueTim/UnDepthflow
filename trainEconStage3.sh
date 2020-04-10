#!/bin/bash

python main.py --data_dir=../datasets/EconTara/ \
	--batch_size=4 --mode=depthflow --train_test=train \
      	--retrain=True --pretrained_model=outForEconStage2/model-242503 \
       	--train_file=../datasets/EconTara/Sequence_030420_135502_8bit/Econ_030420_135502_8bit.txt \
	--gt_2012_dir=../datasets/kitti/gt_stereo_2012/training \
	--gt_2015_dir=../datasets/kitti/gt_scene_2015/training \
	--trace=outEconStage3 --num_gpus=2 \
	--grey_scale=True --img_height=320 --img_width=704

