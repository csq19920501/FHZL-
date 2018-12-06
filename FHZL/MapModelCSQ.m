//
//  MapModel.m
//  FHZL
//
//  Created by hk on 2018/2/1.
//  Copyright © 2018年 hk. All rights reserved.
//

#import "MapModelCSQ.h"

//@interface MapModel () <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
//{
//    BMKLocationService *_locService;
//    BOOL isGetLocation;//是否第一次获取到位置
//}
//@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
//@end
@implementation MapModelCSQ
- (id)init
{
    self = [super init];
    if (self)
    {
        isGetLocation = NO;
        _cityStr = @"深圳市";
        _addressStr = @"深圳市南山智园";
        _userCoordinate = CLLocationCoordinate2DMake( 22.600047,114.011732);
        NSLog(@"当前位置_cityStr = %@",_cityStr);
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        _locService.pausesLocationUpdatesAutomatically = YES;
        _locService.allowsBackgroundLocationUpdates = NO;
        _locService.desiredAccuracy = kCLLocationAccuracyThreeKilometers; //精确度最高
        _locService.headingFilter = 30;
        _locService.distanceFilter = 1000;
        [_locService startUserLocationService];

        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        _geoCodeSearch.delegate = self;
    }
     return self;
}
#pragma mark --- BMKLocationServiceDelegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    _userCoordinate = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    if (!isGetLocation) {
        BMKReverseGeoCodeOption *reverseGeocodeOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeocodeOption.reverseGeoPoint = _userCoordinate;
        [_geoCodeSearch reverseGeoCode:reverseGeocodeOption];
    }
    [_locService stopUserLocationService];
    _locService.delegate = nil;
    _locService = nil;
}
#pragma mark --- BMKSearchServiceDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0)
    {
        isGetLocation = YES;
        if (result.addressDetail.city != nil && ![result.addressDetail.city isEqualToString:@""]) {
            _cityStr = [NSString stringWithFormat:@"%@",result.addressDetail.city];//,result.addressDetail.district
            NSLog(@"_cityStr = %@",_cityStr);

        }
        if (result.poiList.count != 0) {
            BMKPoiInfo *model = result.poiList[0];
            
            _addressStr = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,model.name];
            NSLog(@"result = %@,%@,%@",result.address,result.poiList[0],result.sematicDescription);

        }else{
            _addressStr = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.sematicDescription];
        }
    }
    _geoCodeSearch.delegate = nil;
    _geoCodeSearch = nil;
}
-(void)dealloc{
    
}
@end
