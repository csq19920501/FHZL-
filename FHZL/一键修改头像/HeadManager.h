//
//  HeadManager.h
//  蓝媒智能家居系统
//
//  Created by 英赛智能 on 16/6/9.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvatarPictureViewController.h"
#import "AJPhotoPickerViewController.h"
#import "AJPhotoBrowserViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RSKImageCropViewController.h"


@interface HeadManager : NSObject <AJPhotoPickerProtocol,AJPhotoBrowserDelegate,RSKImageCropViewControllerDelegate,AvatarPictureDelegate>

@property (weak, nonatomic) UIViewController *currentViewController;
@property (copy, nonatomic) void (^cropImageBlock)(UIImage *cropImage);

- (instancetype)initWithTarget:(UIViewController *)target;
- (void)checkCameraAvailability:(void (^)(BOOL auth))block;

- (void)openTakePhoto;

- (void)openPhotoalbums;




@end
