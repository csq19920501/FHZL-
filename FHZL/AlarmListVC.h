//
//  AlarmListVC.h
//  FHZL
//
//  Created by hk on 17/12/21.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationModel.h"
#import "Header.h"
typedef NS_OPTIONS(NSInteger, csqAlarmType) {
    All            = 1,//多个设备
    One              = 2, //单个设备
};
@interface AlarmListVC : RootViewController
@property(nonatomic,assign)csqAlarmType selfType;
@property(nonatomic,strong)LocationModel *carModel;
@end
