//
//  alarmModel.h
//  FHZL
//
//  Created by hk on 18/1/5.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface alarmModel : NSObject
@property(nonatomic,copy)NSString *alarmId;
@property(nonatomic,copy)NSString *macId;
@property(nonatomic,copy)NSString *alarmType;
@property(nonatomic,copy)NSString *alarmDate;
@property(nonatomic,copy)NSString *insDate;
@property(nonatomic,copy)NSString *macName;
@property(nonatomic,copy)NSString *x;
@property(nonatomic,copy)NSString *y;
@property(nonatomic,copy)NSString *speed;
//警报类型为围栏警报时有以下信息
@property(nonatomic,copy)NSString *fenceName;
@property(nonatomic,copy)NSString *fenceRadius;
@property(nonatomic,copy)NSString *fenceX;
@property(nonatomic,copy)NSString *fenceY;
@property(nonatomic,copy)NSString *fenceNum;
@property(nonatomic,copy)NSString *battery;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;
@end
