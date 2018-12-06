//
//  InstructionStateModel.h
//  FHZL
//
//  Created by hk on 2018/1/16.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InstructionStateModel : NSObject
@property(nonatomic,copy)NSString *blindAlarm;// GPS盲区报警
@property(nonatomic,copy)NSString *macType;//设备类型
@property(nonatomic,copy)NSString *sosPhone2;//sos电话2
@property(nonatomic,copy)NSString *sosPhone1;//sos电话1
@property(nonatomic,copy)NSString *re;//1断油状态0恢复状态
@property(nonatomic,copy)NSString *sosPhone3;//sos电话3
@property(nonatomic,copy)NSString *doorAlarm;//车门报警
@property(nonatomic,copy)NSString *version;//版本信息
@property(nonatomic,copy)NSString *mode;//工作模式
@property(nonatomic,copy)NSString *de;//设防状态
@property(nonatomic,copy)NSString *accAlarm;// ACC报警
@property(nonatomic,copy)NSString *moviAlarm;//位移报警
@property(nonatomic,copy)NSString *rmAlarm;// 摘除报警
@property(nonatomic,copy)NSString *macId;
@property(nonatomic,copy)NSString *dr;//门状态
@property(nonatomic,copy)NSString *upDistance;//数据上报间隔距离
@property(nonatomic,copy)NSString *rmsetMode;//摘除后工作模式
@property(nonatomic,copy)NSString *macName;//设备名称
@property(nonatomic,copy)NSString *modeTime;//工作模式时间
@property(nonatomic,copy)NSString *lowbat;// 低电量报警
@property(nonatomic,copy)NSString *vibAlarm;//震动报警
@property(nonatomic,copy)NSString *speedAlarm;//超速报警
@property(nonatomic,copy)NSString *sos;//sos报警
@property(nonatomic,copy)NSString *powerAlarm;//掉B+断电报警
@property(nonatomic,copy)NSString *upType;//0定时上报1定距上报
@property(nonatomic,copy)NSString *upTime;//数据上报间隔时间
@property(nonatomic,copy)NSString *rmsetTime;//摘除后工作时间
@property(nonatomic,copy)NSString *upAccTime;//ACC上报间隔时间
@property(nonatomic,copy)NSString *upAccDistance;//ACC上报间隔距离
@property(nonatomic,copy)NSString *fangchai;//防拆报警
@property(nonatomic,copy)NSString *speedLimit;//超速报警的速度
@property(nonatomic,copy)NSString *speedLimitRunTime;//超速报警的时间
-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)provinceWithDictionary:(NSDictionary*)dict;
@end
