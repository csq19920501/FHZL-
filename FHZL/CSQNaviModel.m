//
//  CSQNaviModel.m
//  FHZL
//
//  Created by hk on 2018/8/3.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "CSQNaviModel.h"
#import "Header.h"
@implementation CSQNaviModel

+(void)sendNaviWithModel:(LocationModel*)model{
    if ([AppData useMapType] == 1)
    {
        NSString *stringURL = [[NSString stringWithFormat:@"baidumap://map/navi?location=%.8f,%.8f&coord_type=bd09ll",[model.y floatValue], [model.x floatValue]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if([AppData useMapType] == 3)
    {
        
        NSLog(@"苹果地图导航  lat %f lng %f",USERMANAGER.mapDetial.userCoordinate.latitude,USERMANAGER.mapDetial.userCoordinate.longitude);
        NSString *str = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f",[model.y floatValue], [model.x floatValue],USERMANAGER.mapDetial.userCoordinate.latitude,USERMANAGER.mapDetial.userCoordinate.longitude];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if([AppData useMapType] == 2)
    {
        CLLocationCoordinate2D _userCoordinate;
        _userCoordinate.latitude = [model.y floatValue];
        _userCoordinate.longitude = [model.x floatValue];
        _userCoordinate = [JZLocationConverter CSQbd09ToWgs84:_userCoordinate];
        
        NSString *stringURL = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",model.addressStr,_userCoordinate.latitude,_userCoordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
