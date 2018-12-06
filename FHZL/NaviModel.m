//
//  NaviModel.m
//  WeiZhong_ios
//
//  Created by hk on 17/9/25.
//
//

#import "NaviModel.h"

@implementation NaviModel
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.addName       = [aDecoder decodeObjectForKey:@"addName"];
        self.content       = [aDecoder decodeObjectForKey:@"content"];
        self.sendTime       = [aDecoder decodeObjectForKey:@"sendTime"];
        self.srcX       = [aDecoder decodeFloatForKey:@"srcX"];
        self.srcY       = [aDecoder decodeFloatForKey:@"srcY"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.addName forKey:@"addName"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.sendTime forKey:@"sendTime"];
    [aCoder encodeFloat:self.srcX forKey:@"srcX"];
    [aCoder encodeFloat:self.srcY forKey:@"srcY"];
}
@end
