//
//  LocationModel.m
//  FHZL
//
//  Created by hk on 17/12/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "LocationModel.h"
#import "NSDictionary+addition.h"
#import "Header.h"
#define  aDecoder(str) [aDecoder decodeObjectForKey:str]
@implementation LocationModel
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        _battery = aDecoder(@"battery");
        _activate = aDecoder(@"activate");
        _bvalid = aDecoder(@"bvalid");
        _dir = aDecoder(@"dir");//方向
        _door = aDecoder(@"door");
        _gpsTime = aDecoder(@"gpsTime");
        _gsmTime = aDecoder(@"gsmTime");
        _macId = aDecoder(@"macId");
        _macName = aDecoder(@"macName");
        _macType = aDecoder(@"macType");
        _online = aDecoder(@"online");
        _speed = aDecoder(@"speed");
        _status = aDecoder(@"status");
        _x = aDecoder(@"x");
        _y = aDecoder(@"y");
        _ico = aDecoder(@"ico");
        _iccid = aDecoder(@"iccid");
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.activate forKey:@"activate"];
    [aCoder encodeObject:self.iccid forKey:@"iccid"];
    [aCoder encodeObject:self.battery forKey:@"battery"];
    [aCoder encodeObject:self.bvalid forKey:@"bvalid"];
    [aCoder encodeObject:self.dir forKey:@"dir"];
    [aCoder encodeObject:self.door forKey:@"door"];
    [aCoder encodeObject:self.gpsTime forKey:@"gpsTime"];
    [aCoder encodeObject:self.gsmTime forKey:@"gsmTime"];
    [aCoder encodeObject:self.macId forKey:@"macId"];
    [aCoder encodeObject:self.macName forKey:@"macName"];
    [aCoder encodeObject:self.macType forKey:@"macType"];
    [aCoder encodeObject:self.online forKey:@"online"];
    [aCoder encodeObject:self.speed forKey:@"speed"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.x forKey:@"x"];
    [aCoder encodeObject:self.y forKey:@"y"];
    [aCoder encodeObject:self.ico forKey:@"ico"];
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
//        [self setValuesForKeysWithDictionary:dict];
        _activate = dict[@"activate"];
        _battery = dict[@"battery"];
//        _activate = dict[@"activate"];
        _bvalid = dict[@"bvalid"];
        _dir = dict[@"dir"];//方向
        _door = dict[@"door"];
        _gpsTime = dict[@"gpsTime"];
        _gsmTime = dict[@"gsmTime"];
        _macId = dict[@"macId"];
        _macName = kStringIsEmpty(dict[@"macName"])?dict[@"macId"]:dict[@"macName"];
        _macType = dict[@"macType"];
//        _macType = @"GT121";
        _online = dict[@"online"];
        _speed = dict[@"speed"];
        _status = dict[@"status"];
        _x = dict[@"x"];
        _y = dict[@"y"];
        _ico = dict[@"ico"];
        _iccid = dict[@"iccid"];
    }
    return self;
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict

{
    return [[self alloc] initWithDictionary:dict];
}

//作者：爱喝可乐的蜗牛
//链接：https://www.jianshu.com/p/531ac1661c90
//來源：简书
//著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
@end
