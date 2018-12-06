//
//  CALayer+PauseAimate.m
//  QQ音乐
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "CALayer+PauseAimate.h"

@implementation CALayer (PauseAimate)

- (void)pauseAnimate
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}
- (void)pauseAnimateCSQ
{
    self.speed = 0.0;
}
- (void)resumeAnimate
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}
- (void)resumeAnimateCSQ
{   
    self.speed = 1.0;
}
@end
