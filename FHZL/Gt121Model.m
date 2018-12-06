//
//  Gt121Model.m
//  FHZL
//
//  Created by hk on 2018/7/11.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "Gt121Model.h"
@implementation Gt121Model
-(instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        _mode = dict[@"mode"];
        _timing = dict[@"timing"];
        _week = dict[@"week"];
        _weekTime= dict[@"weekTime"];
        _weekSel = dict[@"weekSel"];
        _alarmClock = dict[@"alarmClock"];
        _alarmClockTime = dict[@"alarmClockTime"];
        _removeAl = dict[@"removeAl"];
    }
    return self;
}
+(instancetype)provinceWithDictionary:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}
-(instancetype)initWithMode:(Gt121Model*)dict{
    if (self = [super init]) {
        _mode = dict.mode;
        _timing = dict.timing;
        _week = dict.week;
        _weekTime= dict.weekTime;
        _weekSel = dict.weekSel;
        _alarmClock = dict.alarmClock;
        _alarmClockTime = dict.alarmClockTime;
        _removeAl = dict.removeAl;
    }
    return self;
}
@end
