//
//  LDImagePicker.m
//  ImageClipTool
//
//  Created by 段乾磊 on 16/7/6.
//  Copyright © 2016年 LazyDuan. All rights reserved.
//

#import "LDImagePicker.h"
#import "VPImageCropperViewController.h"

#define ScreenWidth  CGRectGetWidth([UIScreen mainScreen].bounds)
#define ScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

@interface LDImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    BOOL isScale;
    double _scale;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) VPImageCropperViewController *imageCropperController;

@end

@implementation LDImagePicker

- (void)showOriginalImagePickerWithType:(ImagePickerType)type
                       InViewController:(UIViewController *)viewController{
    if (type == ImagePickerCamera) {
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }else{
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    isScale = NO;
    self.imagePickerController.allowsEditing = YES;
    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

- (void)showImagePickerWithType:(ImagePickerType)type
               InViewController:(UIViewController *)viewController
                          Scale:(double)scale{
    if (type == ImagePickerCamera) {
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    }else{
        self.imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.imagePickerController.allowsEditing = NO;
    isScale = YES;
    if(scale > 0 && scale <= 1.5){
        _scale = scale;
    }else{
        _scale = 1;
    }
    [viewController presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation = image.imageOrientation;
    if(imageOrientation != UIImageOrientationUp){
        // Adjust picture Angle
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (isScale) {
        self.imageCropperController = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, (ScreenHeight-ScreenWidth * _scale) / 2, ScreenWidth, ScreenWidth * _scale) limitScaleRatio:5];
        __weak typeof(self) weakself = self;
        [_imageCropperController setSubmitblock:^(UIViewController *viewController , UIImage *image) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            if (weakself.delegate) {
                [weakself.delegate imagePicker:weakself didFinished:image];
            }
        }];
        [_imageCropperController setCancelblock:^(UIViewController *viewController){
            UIImagePickerController *picker = (UIImagePickerController *)viewController.navigationController;
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [viewController.navigationController popViewControllerAnimated:YES];
            }
        }];
        [picker pushViewController:self.imageCropperController animated:YES];
    }else{
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self.delegate imagePicker:self didFinished:image];
    }
}

- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
//        UIImagePickerController iOS11调起相册 中的照片被导航栏遮挡
        if (@available(iOS 11, *)) {
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
       
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.editing = YES;
        _imagePickerController.navigationBar.translucent = NO;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

- (void)dealloc{
    
}

@end
