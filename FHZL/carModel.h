//
//  carModel.h
//  GT
//
//  Created by hk on 17/6/3.
//  Copyright © 2017年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>
//{
//    "macType"：//设备类型
//    
//    "upType"：0 //0定时上报1定距上报
//    "upTime"：60//上传间隔时间
//    "upAccTime"：60//ACC上报间隔时间
//    "upDistance"：60//数据上报间隔距离
//    "upAccDistance"：60//ACC上报间隔距离
//    
//    "simIMSI"：//simIMSI
//    "simICCID"：//simICCID
//    "version"：//设备版本
//    "sosPhone1"：//电话1
//    "sosPhone1"：//电话2
//    "sosPhone1"：//电话3
//    
//    "dr"：0//门状态0关闭 1打开
//    "re"：0//0断油状态1正常
//    "de"：0//0撤防1设防
//    
//    //0报警关 1报警开
//    "vibAlarm"：0//震动报警
//    "powerAlarm"：0//掉B+断电报警
//    "sos"：0//sos报警
//    "moviAlarm"：0//位移报警
//    "speedAlarm"：0//超速报警
//    "doorAlarm"：0//车门报警
//    "blindAlarm"：0//GPS盲区报警
//    "accAlarm"：0//ACC报警
//    "lowbat"：0//低电量报警
//}

@interface carModel : NSObject<NSCoding>
@property(nonatomic,assign)NSInteger carBattery;
@property(nonatomic,assign)NSInteger recordTimeInt;
@property(nonatomic,assign)NSInteger ul;
@property(nonatomic,copy)NSString *carACC;
@property(nonatomic,copy)NSString *devicestatus;
@property(nonatomic,copy)NSString *carOilState;
@property(nonatomic,copy)NSString *defenceState;
@property(nonatomic,copy)NSString *carAddress;
@property(nonatomic,copy)NSString *carLat;
@property(nonatomic,copy)NSString *carLng;
@property(nonatomic,copy)NSString *gpstime;
@property(nonatomic,copy)NSString *gpsType;
@property(nonatomic,copy)NSString *deviceName;
@property(nonatomic,copy)NSString *doorState;
@property(nonatomic,copy)NSString *deviceType;
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *de;
@property(nonatomic,copy)NSString *sosPhone1;
@property(nonatomic,copy)NSString *sosPhone2;
@property(nonatomic,copy)NSString *sosPhone3;
@property(nonatomic,copy)NSString *sos;
@property(nonatomic,copy)NSString *powerAlarm;
@property(nonatomic,copy)NSString *moviAlarm;
@property(nonatomic,copy)NSString *speedAlarm;
@property(nonatomic,copy)NSString *doorAlarm;
@property(nonatomic,copy)NSString *blindAlarm;
@property(nonatomic,copy)NSString *accAlarm;
@property(nonatomic,copy)NSString *lowbat;
@property(nonatomic,copy)NSString *vibAlarm;
@property(nonatomic,copy)NSString *devicePhone;
@end
