//
//  AvatarPictureViewController.m
//  QRscanText
//
//  Created by cchhjj on 16/3/31.
//  Copyright © 2016年 cchhjj. All rights reserved.
//

#import "AvatarPictureViewController.h"
#import "LLSimpleCamera.h"
//#import "RSKImageCropViewController.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface AvatarPictureViewController () <LLSimpleCameraDelegate>

@property (weak, nonatomic) IBOutlet UIButton *takeButton;//拍照按钮
@property (weak, nonatomic) IBOutlet UIButton *flashAutoButton;//自动闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *flashOnButton;//打开闪光灯按钮
@property (weak, nonatomic) IBOutlet UIButton *flashOffButton;//关闭闪光灯按钮
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor; //聚焦光标
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) IBOutlet UIView *backView;

@end

@implementation AvatarPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    _camera = [[LLSimpleCamera alloc]initWithQuality:CameraQualityPhoto];
    [_camera attachToViewController:self withDelegate:self];
    self.camera.view.frame = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height);
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.backView];
    [self.view bringSubviewToFront:_takeButton];
    [self.view bringSubviewToFront:_flashOnButton];
}
- (IBAction)takePhoto:(UIButton *)sender {
    [self.camera capture];
}

- (IBAction)exitCamera:(UIButton *)sender {
    [self.camera stop];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)cameraViewController:(LLSimpleCamera*)cameraVC
             didChangeDevice:(AVCaptureDevice *)device {
    
}

- (void)cameraViewController:(LLSimpleCamera*)cameraVC
             didCaptureImage:(UIImage *)image {
    [self.camera stop];
    NSLog(@"didCaptureImage %@",NSStringFromCGSize(image.size));
    
    if ([self.delegate respondsToSelector:@selector(avatarPictureViewController:captureImage:)]) {
        [self.delegate avatarPictureViewController:self captureImage:image];
    }
    
}
 
//- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
//{
//
//
//
//}



@end
