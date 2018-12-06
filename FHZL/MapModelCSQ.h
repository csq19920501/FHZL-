//
//  MapModel.h
//  FHZL
//
//  Created by hk on 2018/2/1.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
@interface MapModelCSQ : NSObject <BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    BOOL isGetLocation;//是否第一次获取到位置
}
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property(nonatomic,copy)NSString *addressStr;
@property(nonatomic,copy)NSString *cityStr;

@property(nonatomic,assign)CLLocationCoordinate2D userCoordinate;

@end
