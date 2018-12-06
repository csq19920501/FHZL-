//
//  ShareView.h
//  JShareDemo
//
//  Created by ys on 11/01/2017.
//  Copyright © 2017 ys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSHAREService.h"

typedef void(^ShareBlock)(JSHAREPlatform platform, JSHAREMediaType type);

@interface ShareView : UIView
@property(nonatomic,strong)NSDictionary* shareDictionary;

+ (ShareView *)getFactoryShareViewWithCallBack:(ShareBlock)block;

- (void)showWithContentType:(JSHAREMediaType)type;
- (void)showWithSupportedLoginPlatform;
+ (ShareView *)getFactoryShareViewWithCsqDiction:(NSDictionary*)dict;
-(void)showInView:(UIView*)view;
@end
