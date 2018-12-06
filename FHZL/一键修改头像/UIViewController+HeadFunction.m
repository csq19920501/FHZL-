//
//  UIViewController+HeadFunction.m
//  蓝媒智能家居系统
//
//  Created by cchhjj on 16/6/10.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import "UIViewController+HeadFunction.h"
#import "UIViewController+ActionSheet.h"
#import <objc/runtime.h>

static const char *HeadManagerKey = "HeadManagerKey";
static const char *HeadPictureViewKey = "HeadPictureViewKey";

@implementation UIViewController (HeadFunction)

- (void)setHeadPictureView:(UIImageView *)headPictureView {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, HeadPictureViewKey, headPictureView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIImageView *)headPictureView {
    return objc_getAssociatedObject(self, HeadPictureViewKey);
}


- (void)setHeadManager:(HeadManager *)headManager {
    objc_setAssociatedObject(self, HeadManagerKey, headManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HeadManager *)headManager {
    return objc_getAssociatedObject(self, HeadManagerKey);
}

#pragma mark - ChangeHeadImage
- (void)changeHeadImageWithHeadImageView:(UIImageView *)headImageView{
    self.headPictureView = headImageView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageChange:)];
    self.headPictureView.userInteractionEnabled = YES;
    [self.headPictureView addGestureRecognizer:tap];
}


- (void)headImageChange:(UIGestureRecognizer *)tap{
    
    NSNotificationCenter *notificationDefaultCenter = [NSNotificationCenter defaultCenter];
    if (tap.state == UIGestureRecognizerStateEnded) {
        self.headManager = [[HeadManager alloc] initWithTarget:self];
        __weak __typeof(self) weakSelf = self;
        self.headManager.cropImageBlock = ^(UIImage *cropImage){
            weakSelf.headPictureView.image = cropImage;
            [notificationDefaultCenter postNotificationName:headImageUpdateNotificationKey object:nil userInfo:@{headImageValue:cropImage}];
            weakSelf.headManager = nil;
        };
        [self actionSheet:^{
            [self.headManager checkCameraAvailability:^(BOOL auth) {
                if (!auth) {
                    NSLog(@"没有访问相机权限");
                    return;
                }
            }];
            [self.headManager openTakePhoto];
        } ppBlock:^{
            [self.headManager openPhotoalbums];
        }];
    }
    
}
-(void)csqPhoneClick{
    NSNotificationCenter *notificationDefaultCenter = [NSNotificationCenter defaultCenter];
    self.headManager = [[HeadManager alloc] initWithTarget:self];
    __weak __typeof(self) weakSelf = self;
    self.headManager.cropImageBlock = ^(UIImage *cropImage){
        weakSelf.headPictureView.image = cropImage;
        [notificationDefaultCenter postNotificationName:headImageUpdateNotificationKey object:nil userInfo:@{headImageValue:cropImage}];
        weakSelf.headManager = nil;
    };
    [self csqActionSheet:^{
        [self.headManager checkCameraAvailability:^(BOOL auth) {
            if (!auth) {
                NSLog(@"没有访问相机权限");
                return;
            }
        }];
        [self.headManager openTakePhoto];
    } ppBlock:^{
        [self.headManager openPhotoalbums];
    } csqBlock:^{
//        [self.headManager openPhotoalbums];
//        if (self.headBlock) {
//            self.headBlock();
//        }
        [notificationDefaultCenter postNotificationName:gotoHeadImageOrWeiXinNoti object:nil ];
    }];
}
//meiyoufangwenquanxian  gongzuoxuqiu  nihao shijie headmanager openphoto openPhotoalbums
@end
