//
//  CYButton.h
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define isIphoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20?YES:NO)
@interface CYButton : UIButton
/** item */
@property (weak , nonatomic) UITabBarItem *item;
@end
