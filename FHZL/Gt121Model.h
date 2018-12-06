//
//  Gt121Model.h
//  FHZL
//
//  Created by hk on 2018/7/11.
//  Copyright © 2018年 hk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gt121Model : NSObject
@property(nonatomic,copy)NSString *mode;//int  1两年模式|2三年模式
@property(nonatomic,copy)NSString *timing;//int  1-999
@property(nonatomic,copy)NSString *week;////int  1打开|0关闭
@property(nonatomic,copy)NSString *weekTime;////String 时间  09:00
@property(nonatomic,copy)NSString *weekSel;//int[] 选择的周1-7
@property(nonatomic,copy)NSString *alarmClock; //int  1打开|0关闭
@property(nonatomic,copy)NSString *alarmClockTime;//String[]  闹钟时间，1500=15:00
@property(nonatomic,copy)NSString *removeAl;//int  1打开|0关闭
-(instancetype)initWithDictionary:(NSDictionary*)dict;
+(instancetype)provinceWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithMode:(Gt121Model*)dict;
@end
