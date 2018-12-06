//
//  InstructionModel.m
//  FHZL
//
//  Created by hk on 2018/1/10.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "InstructionModel.h"

@implementation InstructionModel
-(instancetype)initWithDictionary:(NSDictionary*)dict{
    if (self = [super init]) {
        _IMEI = dict[@"imei"];
        _createtime = dict[@"createtime"];
        _instrID = dict[@"id"];
        _instruct_name = dict[@"instruct_name"];
        _instruct = dict[@"instruct"];
        _status = dict[@"status"];
        _status_desc = dict[@"status_desc"];
    }
    return self;
}
+(instancetype)provinceWithDictionary:(NSDictionary*)dict{
    return [[self alloc] initWithDictionary:dict];
}
@end
