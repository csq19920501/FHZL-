//
//  AlarmParams.h
//  iBluz
//
//  Created by Inid on 15/2/13.
//  Copyright (c) 2015年 Actions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmParams : NSObject

@property(nonatomic, readwrite)UInt32 snoozeCount;
@property(nonatomic, readwrite)UInt32 snoozeDuration;
@property(nonatomic, readwrite)UInt32 snoozeOvertime;

@end
