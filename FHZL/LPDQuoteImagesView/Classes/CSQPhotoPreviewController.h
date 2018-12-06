//
//  CSQPhotoPreviewController.h
//  FHZL
//
//  Created by hk on 2018/2/6.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSQPhotoPreviewController : UIViewController
@property (nonatomic, strong) NSMutableArray *photos;                  ///< All photos  / 所有图片数组
@property (nonatomic, assign) NSInteger currentIndex;           ///< Index of the photo user cli
@property (nonatomic,copy) void (^didDismiss)();
@end
