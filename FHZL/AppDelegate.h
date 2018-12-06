//
//  AppDelegate.h
//  FHZL
//
//  Created by hk on 17/12/11.
//  Copyright © 2017年 hk. All rights reserved.
//

static NSString *appKey = @"817683c767bcd4eb4dc5e80a";
static NSString *channel = @"appStore";
static BOOL isProduction = FALSE;

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) MMDrawerController * drawerController;
@property (copy, nonatomic) NSString *headImageStr; //头像连接
-(void)setMain;
-(void)setRootMainVC;
-(void)setRootLoginVC;
@end

