//
//  NSObject+objectFormDict.h
//  FHZL
//
//  Created by hk on 18/1/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (objectFormDict)
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;
@end
