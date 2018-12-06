//
//  carModel.m
//  GT
//
//  Created by hk on 17/6/3.
//  Copyright © 2017年 hk. All rights reserved.
//

#import "carModel.h"
@implementation carModel
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.devicestatus       = [aDecoder decodeObjectForKey:@"devicestatus"];
        self.carACC       = [aDecoder decodeObjectForKey:@"carACC"];
        self.gpsType       = [aDecoder decodeObjectForKey:@"gpsType"];
        self.carOilState       = [aDecoder decodeObjectForKey:@"carOilState"];
        self.defenceState       = [aDecoder decodeObjectForKey:@"defenceState"];
        self.carAddress       = [aDecoder decodeObjectForKey:@"carAddress"];
        self.carLat = [aDecoder decodeObjectForKey:@"carLat"];
        self.carLng    = [aDecoder decodeObjectForKey:@"carLng"];
        self.gpstime         = [aDecoder decodeObjectForKey:@"gpstime"];
        self.deviceName         = [aDecoder decodeObjectForKey:@"deviceName"];
        self.carBattery  = [aDecoder decodeIntegerForKey:@"carBattery"];
        self.recordTimeInt  = [aDecoder decodeIntegerForKey:@"recordTimeInt"];
        self.doorState  = [aDecoder decodeObjectForKey:@"doorState"];
        
        self.sosPhone1  = [aDecoder decodeObjectForKey:@"sosPhone1"];
        self.sosPhone2  = [aDecoder decodeObjectForKey:@"sosPhone2"];
        self.sosPhone3  = [aDecoder decodeObjectForKey:@"sosPhone3"];
        self.sos  = [aDecoder decodeObjectForKey:@"sos"];
        self.powerAlarm  = [aDecoder decodeObjectForKey:@"powerAlarm"];
        self.moviAlarm  = [aDecoder decodeObjectForKey:@"moviAlarm"];
        self.speedAlarm  = [aDecoder decodeObjectForKey:@"speedAlarm"];
        self.doorAlarm  = [aDecoder decodeObjectForKey:@"doorAlarm"];
        self.blindAlarm  = [aDecoder decodeObjectForKey:@"blindAlarm"];
        self.accAlarm  = [aDecoder decodeObjectForKey:@"accAlarm"];
        self.lowbat  = [aDecoder decodeObjectForKey:@"lowbat"];
        self.vibAlarm  = [aDecoder decodeObjectForKey:@"vibAlarm"];
        self.devicePhone  = [aDecoder decodeObjectForKey:@"devicePhone"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.devicestatus forKey:@"devicestatus"];
    [aCoder encodeObject:self.gpsType forKey:@"gpsType"];
    [aCoder encodeObject:self.vibAlarm forKey:@"vibAlarm"];
    [aCoder encodeObject:self.sosPhone1 forKey:@"sosPhone1"];
    [aCoder encodeObject:self.sosPhone2 forKey:@"sosPhone2"];
    [aCoder encodeObject:self.sosPhone3 forKey:@"sosPhone3"];
    [aCoder encodeObject:self.sos forKey:@"sos"];
    [aCoder encodeObject:self.powerAlarm forKey:@"powerAlarm"];
    [aCoder encodeObject:self.lowbat forKey:@"lowbat"];
    [aCoder encodeObject:self.moviAlarm forKey:@"moviAlarm"];
    [aCoder encodeObject:self.speedAlarm forKey:@"speedAlarm"];
    [aCoder encodeObject:self.doorAlarm forKey:@"doorAlarm"];
    [aCoder encodeObject:self.blindAlarm forKey:@"blindAlarm"];
    [aCoder encodeObject:self.accAlarm forKey:@"accAlarm"];
    
    [aCoder encodeObject:self.carACC forKey:@"carACC"];
    [aCoder encodeObject:self.doorState forKey:@"doorState"];
    [aCoder encodeObject:self.carOilState forKey:@"carOilState"];
    [aCoder encodeObject:self.defenceState forKey:@"defenceState"];
    [aCoder encodeObject:self.carAddress forKey:@"carAddress"];
    [aCoder encodeObject:self.carLat forKey:@"carLat"];
    [aCoder encodeObject:self.carLng forKey:@"carLng"];
    [aCoder encodeObject:self.gpstime forKey:@"gpstime"];
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.devicePhone forKey:@"devicePhone"];
    [aCoder encodeInteger:self.carBattery forKey:@"carBattery"];
    [aCoder encodeInteger:self.recordTimeInt forKey:@"recordTimeInt"];
}

@end
