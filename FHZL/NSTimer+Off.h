//
//  NSTimer+Off.h
//  car
//
//  Created by apple on 15/4/18.
//  Copyright (c) 2015年 xy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Off)

-(void)pause;
-(void)resume;
-(void)resumeWithTimeInterval:(NSTimeInterval)timeInterval;
@end
