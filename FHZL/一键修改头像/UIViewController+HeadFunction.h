//
//  UIViewController+HeadFunction.h
//  蓝媒智能家居系统
//
//  Created by cchhjj on 16/6/10.
//  Copyright © 2016年 BlueMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadManager.h"



@interface UIViewController (HeadFunction)

@property (strong, nonatomic) HeadManager *headManager;
@property (weak, nonatomic) UIImageView *headPictureView;
@property (copy,nonatomic)void (^headBlock)();
- (void)changeHeadImageWithHeadImageView:(UIImageView *)headImageView;
- (void)csqPhoneClick;
@end

static  NSString *headImageUpdateNotificationKey = @"headImageUpdateNotificationKey";
static const NSString *headImageValue = @"headImageValue";
static NSString *gotoHeadImageOrWeiXinNoti = @"gotoHeadImageOrWeiXinNoti";
