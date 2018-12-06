//
//  alarmModel.m
//  FHZL
//
//  Created by hk on 18/1/5.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "alarmModel.h"
#import "Header.h"
@implementation alarmModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
        _alarmDate = dict[@"alarmDate"];
        _alarmType = dict[@"alarmType"];
        _battery = dict[@"battery"];
        _fenceName = dict[@"fenceName"];
        _fenceNum = dict[@"fenceNum"];
        _fenceRadius = dict[@"fenceRadius"];
        _fenceX = dict[@"fenceX"];
        _fenceY = dict[@"fenceY"];
        _alarmId = dict[@"id"];
        _insDate = dict[@"insDate"];
        _macId = dict[@"macId"];
        _speed = dict[@"speed"];
        _macName = dict[@"macName"];
        if (kStringIsEmpty(_macName)) {
            _macName = dict[@"macId"];
        }
        
        _x = dict[@"x"];
        _y = dict[@"y"];
//        _alarmId = dict[@"id"];
    }
    return self;
    
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{
    return [[self alloc] initWithDictionary:dict];
}
@end
