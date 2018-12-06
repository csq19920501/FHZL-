//
//  InstructionStateModel.m
//  FHZL
//
//  Created by hk on 2018/1/16.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "InstructionStateModel.h"
#import "NSDictionary+addition.h"
@implementation InstructionStateModel
-(instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        _blindAlarm = dict[@"blindAlarm"];
        _macType = dict[@"macType"];
        _sosPhone2 = dict[@"sosPhone2"];
        _sosPhone1 = dict[@"sosPhone1"];
        _re = dict[@"re"];
        _sosPhone3 = dict[@"sosPhone3"];
        _doorAlarm = dict[@"doorAlarm"];
        _version = dict[@"version"];
        _mode = dict[@"mode"];
        _de = dict[@"de"];
        _accAlarm = dict[@"accAlarm"];
        _moviAlarm = dict[@"moviAlarm"];
        _rmAlarm = dict[@"rmAlarm"];
        _macId = dict[@"macId"];
        _dr = dict[@"dr"];
        _upDistance = dict[@"upDistance"];
        _rmsetMode = dict[@"rmsetMode"];
        _macName = dict[@"macName"];
        _modeTime = dict[@"modeTime"];
        _lowbat = dict[@"lowbat"];
        _vibAlarm = dict[@"vibAlarm"];
        _speedAlarm = dict[@"speedAlarm"];
        _sos = dict[@"sos"];
        _powerAlarm = dict[@"powerAlarm"];
        _upType = dict[@"upType"];
        _upTime = dict[@"upTime"];
        _rmsetTime = dict[@"rmsetTime"];
        _upAccTime = dict[@"upAccTime"];
        _upAccDistance = dict[@"upAccDistance"];
        _fangchai = dict[@"fangchai"];//gt121待修改
        _speedLimit =  [dict getStringValueForKey:@"speed" defaultValue:@"120"];
        _speedLimitRunTime = [dict getStringValueForKey:@"runTime" defaultValue:@"10"];
    }
    return self;
}
+(instancetype)provinceWithDictionary:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}
@end
