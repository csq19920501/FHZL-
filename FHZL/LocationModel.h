//
//  LocationModel.h
//  FHZL
//
//  Created by hk on 17/12/27.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LocationModel : NSObject<NSCoding>
@property(nonatomic,copy)NSString *macId;
@property(nonatomic,copy)NSString *macType;
@property(nonatomic,copy)NSString *macName;
@property(nonatomic,copy)NSString *CarImage;
@property(nonatomic,copy)NSString *battery;
@property(nonatomic,copy)NSString *y;
@property(nonatomic,copy)NSString *x;
@property(nonatomic,copy)NSString *gpsTime;//定位时间
@property(nonatomic,copy)NSString *gsmTime;//信号时间
@property(nonatomic,copy)NSString *bvalid;//定位方式0未定位，1GPS，2及以上基站定位
@property(nonatomic,copy)NSString *status; //点火0未点火，1点火
@property(nonatomic,copy)NSString *speed;
@property(nonatomic,copy)NSString *dir;//方向
@property(nonatomic,copy)NSString *door;//门0关1开
@property(nonatomic,copy)NSString *online;//0不在线1在线
@property(nonatomic,copy)NSString *activate;//0未激活1激活
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,assign)int tagNumber;
@property(nonatomic,copy)NSString *addressStr;//反编译地址
@property(nonatomic,copy)NSString *imei;
@property(nonatomic,copy)NSString *imis;
@property(nonatomic,copy)NSString *sim;
@property(nonatomic,copy)NSString *activateDate;
@property(nonatomic,copy)NSString *effectiveDate;
@property(nonatomic,copy)NSString *ico;
@property(nonatomic,copy)NSString *iccid;


- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;

@end
