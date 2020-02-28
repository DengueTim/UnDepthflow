import numpy as np
import os
import cv2, skimage
import skimage.io
import scipy.misc as sm
from flowlib import write_flow_png


def sm_crop_n_resize(img, new_W, new_H, return_translation=False):
    def smResize(img, height, width):
        return sm.imresize(img, (height, width))
    return __crop_n_resize(img, new_W, new_H, return_translation, smResize)


def cv2_crop_n_resize(img, new_W, new_H, return_translation=False):
    def cv2resize(img, height, width):
        return cv2.resize(img, (width, height), interpolation=cv2.INTER_LINEAR)

    return __crop_n_resize(img, new_W, new_H, return_translation, cv2resize)

def __crop_n_resize(img, new_W, new_H, return_translation, resize_func):
    orig_H, orig_W = img.shape[0:2]

    orig_aspect_ratio = float(orig_W) / orig_H
    required_aspect_ratio = float(new_H) / new_W

    crop_height = orig_H
    crop_width = orig_W
    offset_y = 0
    offset_x = 0

    if (required_aspect_ratio / orig_aspect_ratio) > 1.02:
        crop_height = int(orig_W / required_aspect_ratio)
        offset_y = int((orig_H - crop_height) / 2)

    if (orig_aspect_ratio / required_aspect_ratio) > 1.02:
        crop_width = int(orig_H * required_aspect_ratio)
        offset_x = int((orig_W - crop_width) / 2)

    img = img[offset_y:offset_y + crop_height, offset_x:offset_x + crop_width]
    img = resize_func(img, new_H, new_W)

    zoom_y = new_H / crop_height
    zoom_x = new_W / crop_width

    if return_translation:
        return img, zoom_x, zoom_y, offset_x, offset_y
    else:
        return img


# Adopted from https://github.com/mrharicot/monodepth
def compute_errors(gt, pred):
    thresh = np.maximum((gt / pred), (pred / gt))
    a1 = (thresh < 1.25).mean()
    a2 = (thresh < 1.25**2).mean()
    a3 = (thresh < 1.25**3).mean()

    rmse = (gt - pred)**2
    rmse = np.sqrt(rmse.mean())

    rmse_log = (np.log(gt) - np.log(pred))**2
    rmse_log = np.sqrt(rmse_log.mean())

    abs_rel = np.mean(np.abs(gt - pred) / (gt))

    sq_rel = np.mean(((gt - pred)**2) / (gt))

    return abs_rel, sq_rel, rmse, rmse_log, a1, a2, a3


###############################################################################
#######################  KITTI

width_to_focal = dict()
width_to_focal[1242] = 721.5377
width_to_focal[1241] = 718.856
width_to_focal[1224] = 707.0493
width_to_focal[1238] = 718.3351


def load_gt_disp_kitti(path, eval_occ):
    gt_disparities = []
    for i in range(200):
        if eval_occ:
            disp = sm.imread(
                path + "/disp_occ_0/" + str(i).zfill(6) + "_10.png", -1)
        else:
            disp = sm.imread(
                path + "/disp_noc_0/" + str(i).zfill(6) + "_10.png", -1)
        disp = disp.astype(np.float32) / 256.0
        gt_disparities.append(disp)
    return gt_disparities


def convert_disps_to_depths_kitti(gt_disparities, pred_disparities):
    gt_depths = []
    pred_depths = []
    pred_disparities_resized = []

    for i in range(len(gt_disparities)):
        gt_disp = gt_disparities[i]
        height, width = gt_disp.shape

        pred_disp = pred_disparities[i]
        pred_disp = width * cv2.resize(
            pred_disp, (width, height), interpolation=cv2.INTER_LINEAR)

        pred_disparities_resized.append(pred_disp)

        mask = gt_disp > 0

        gt_depth = width_to_focal[width] * 0.54 / (gt_disp + (1.0 - mask))
        pred_depth = width_to_focal[width] * 0.54 / pred_disp

        gt_depths.append(gt_depth)
        pred_depths.append(pred_depth)
    return gt_depths, pred_depths, pred_disparities_resized


def write_test_results(test_result_flow_optical, test_result_disp,
                       test_result_disp2, test_image1, opt, mode):
    output_dir = opt.trace
    os.mkdir(os.path.join(output_dir, mode))
    os.mkdir(os.path.join(output_dir, mode, "flow"))
    os.mkdir(os.path.join(output_dir, mode, "disp_0"))
    os.mkdir(os.path.join(output_dir, mode, "disp_1"))

    for flow, disp0, disp1, img1, i in zip(test_result_flow_optical,
                                           test_result_disp, test_result_disp2,
                                           test_image1,
                                           range(len(test_image1))):
        H, W = img1.shape[0:2]
        flow[:, :, 0] = flow[:, :, 0] / opt.img_width * W
        flow[:, :, 1] = flow[:, :, 1] / opt.img_height * H

        flow = cv2.resize(flow, (W, H), interpolation=cv2.INTER_LINEAR)
        write_flow_png(flow,
                       os.path.join(output_dir, mode, "flow",
                                    str(i).zfill(6) + "_10.png"))

        disp0 = W * cv2.resize(disp0, (W, H), interpolation=cv2.INTER_LINEAR)
        skimage.io.imsave(
            os.path.join(output_dir, mode, "disp_0",
                         str(i).zfill(6) + "_10.png"),
            (disp0 * 256).astype('uint16'))

        disp1 = W * cv2.resize(disp1, (W, H), interpolation=cv2.INTER_LINEAR)
        skimage.io.imsave(
            os.path.join(output_dir, mode, "disp_1",
                         str(i).zfill(6) + "_10.png"),
            (disp1 * 256).astype('uint16'))
