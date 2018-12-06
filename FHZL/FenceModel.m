//
//  FenceModel.m
//  FHZL
//
//  Created by hk on 18/1/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "FenceModel.h"

@implementation FenceModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
        _fenceId = dict[@"id"];
        _activate = dict[@"activate"];
        _name = dict[@"name"];
        _macId = dict[@"macId"];
        _num = dict[@"num"];
        _radius = dict[@"radius"];
        _x = dict[@"x"];
        _y = dict[@"y"];
        _address = dict[@"address"];
    }
    return self;
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{
    return [[self alloc] initWithDictionary:dict];
}
@end
