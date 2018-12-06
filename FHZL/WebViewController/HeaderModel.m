//
//  HeaderModel.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/23.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "HeaderModel.h"
#import <UIKit/UIKit.h>
#import <YYKit.h>
@implementation HeaderModel

-(instancetype)init{
    self = [super init];
    if (self) {
        self.userid = 123456789;//userManager.curUserInfo.userid;
        self.imei = [OpenUDID value].length>32 ? [[OpenUDID value] substringToIndex:32] :[OpenUDID value];
        self.os_type = 2;
        self.version = [UIApplication sharedApplication].appVersion;
        self.channel = @"App Store";
        self.clientId = self.imei;//[OpenUDID value].length>32 ? [[OpenUDID value] substringToIndex:32] :[OpenUDID value];
        self.versioncode = 1;
        self.mobile_model = [UIDevice currentDevice].machineModelName;
        self.mobile_brand = [UIDevice currentDevice].machineModel;
    }
    return self;
}
@end
