//
//  NSTimer+Off.m
//  car
//
//  Created by apple on 15/4/18.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import "NSTimer+Off.h"

@implementation NSTimer (Off)

-(void)pause{
    if (![self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

-(void)resume{
    if (![self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

-(void)resumeWithTimeInterval:(NSTimeInterval)timeInterval{
    if (![self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
    }
}


@end
