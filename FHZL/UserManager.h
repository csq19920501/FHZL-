/*
 ============================================================================
 Name        : UserManager.h
 Version     : 1.0.0
 Copyright   : 
 Description : 用户管理类
 ============================================================================
 */
#define orderNum @"orderNum"
#define SUIPAI @"suipai"
#define MUSIC @"Music"
#define BLACK @"Black"
#define GT10  @"GT10"
#define GT31  @"GT31"
#define DR_30 @"GT32"//@"DR30"
#define GT51 @"GT51"
#define GT121 @"GT121"
#define GT52 @"GT52"

#define DRINKGLASS  @"DRINKGLASS"
#define GT10ARRAY  @"GT10ARRAY"
#define TYPE @"TYPE"
#import <Foundation/Foundation.h>
#import "User.h"
#import "carModel.h"
#import "LocationModel.h"
#import "FilterModel.h"
#import "MapModelCSQ.h"

@interface UserManager : NSObject
{
}
@property(nonatomic,strong)MapModelCSQ *mapDetial;
@property (nonatomic, readonly) User2* user;
@property(nonatomic,strong)carModel *device;
@property(nonatomic,strong)LocationModel *seleCar;
@property(nonatomic,strong)FilterModel *filterModel;
@property(nonatomic,strong)NSMutableArray *GT10CarArray;
@property(nonatomic,strong)NSMutableArray *deviceArray;
@property(nonatomic,strong)NSMutableArray *AllDeviceArray;
+ (UserManager*)sharedInstance;
+ (void)destroyInstance;
// 保存用户信息
- (void)save;
// 清除用户信息
- (void)clear;
//获取当前时间字符串
+(NSString *)getDateStrFormNow;
//时间戳转手机系统时区时间字符串
+(NSString *)getDateDisplayString:(long long) miliSeconds;
//时间戳转手机系统时区时间字符串 不包含时分秒
+(NSString *)getDateDisplayShortString:(long long) miliSeconds;
//字符串转时间戳
+(long long)getTimerInterval:(NSString *) dateStr;
//零时区时间字符串转手机系统时区字符串
+(NSString *)changeDataStrWithStrInZero:(NSString*)zeroDataStr;
//系统时区字符串转零时区字符串
+(NSString *)changeDataStrWithLocalToZero:(NSString*)localDataStr;
//系统时区仅仅小时分钟字符串转零时区字符串
+(NSString *)changeHourDataStrFromLocalToZero:(NSString*)localDataStr;
//与上相反
+(NSString *)changeHourDataStrFromZeroToLocal:(NSString*)zeroDataStr;
@end
