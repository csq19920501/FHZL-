//
//  AvatarPictureViewController.h
//  QRscanText
//
//  Created by cchhjj on 16/3/31.
//  Copyright © 2016年 cchhjj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AvatarPictureDelegate;

@interface AvatarPictureViewController : UIViewController

@property (weak, nonatomic) id<AvatarPictureDelegate> delegate;


@end

@protocol AvatarPictureDelegate <NSObject>
@optional

- (void)avatarPictureViewController:(AvatarPictureViewController *)avatarPictureVC captureImage:(UIImage *)captureImage;

@end