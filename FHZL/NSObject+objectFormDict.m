//
//  NSObject+objectFormDict.m
//  FHZL
//
//  Created by hk on 18/1/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "NSObject+objectFormDict.h"

@implementation NSObject (objectFormDict)
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{
    return [[self alloc] initWithDictionary:dict];
}

@end
