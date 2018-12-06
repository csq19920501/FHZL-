//
//  ImageScrollView.h
//  car
//
//  Created by apple on 15/3/27.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYImageScrollView : UIView
@property (nonatomic,assign)  BOOL aoutScroll;
@property (nonatomic,assign)  NSTimeInterval time;
@property (nonatomic,strong)  NSArray *images;
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);
@end
