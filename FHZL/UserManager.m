/*
 ============================================================================
 Name        : UserManager.m
 Version     : 1.0.0
 Copyright   : 
 Description : 用户管理类
 ============================================================================
 */



#import "UserManager.h"

@interface UserManager ()
{
    User2* _user;
}

@end

@implementation UserManager

static UserManager* _sharedInstance;

@synthesize user = _user;

/***********************************************************************
 * 方法名称： sharedInstance
 * 功能描述： 获取用户管理对象
 * 输入参数：
 * 输出参数：
 * 返回值：   用户管理对象
 ***********************************************************************/
+ (UserManager*)sharedInstance
{
    if (nil == _sharedInstance)
    {
        _sharedInstance = [[UserManager alloc] init];
    }
	return _sharedInstance;
}

/***********************************************************************
 * 方法名称： destroyInstance
 * 功能描述： 销毁用户管理对象
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
+ (void)destroyInstance
{
    if (nil != _sharedInstance)
    {
        _sharedInstance = nil;
    }
}
/***********************************************************************
 * 方法名称： init
 * 功能描述： 生成用户管理对象
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (id)init
{
    self = [super init];
    if (self)
    {
        _GT10CarArray = [NSMutableArray array];
        _deviceArray = [NSMutableArray array];
        _AllDeviceArray = [NSMutableArray array];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSData* data = [userDefaults objectForKey:@"UserInfo"];
        NSData* filterData = [userDefaults objectForKey:@"filterData"];
//        NSData* deviceData = [userDefaults objectForKey:@"DeviceInfo"];
        NSData* AllDeviceData = [userDefaults objectForKey:@"AllDeviceArray"];
        _user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _filterModel = [NSKeyedUnarchiver unarchiveObjectWithData:filterData];
        NSData* gt10CarArrayData = [userDefaults objectForKey:@"GT10CarArrayData"];
        [_GT10CarArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:gt10CarArrayData]];
        if (nil == _user){
            _user = [[User2 alloc] init];
        }
        if (_filterModel == nil) {
            _filterModel = [[FilterModel alloc]init];
            [_filterModel setAll];
        }

        [_AllDeviceArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:AllDeviceData]];
       
        if (_AllDeviceArray.count == 0) {
            if (_device == nil) {
                _device = [[carModel alloc]init];
            }
            NSDictionary *dictMusic = @{TYPE:SUIPAI};

//            NSDictionary *dictGT10 = @{TYPE:GT10,GT10:_device,GT10ARRAY:_deviceArray};
            [_AllDeviceArray addObjectsFromArray:@[dictMusic]];
        }else{
            for (NSDictionary *dict in _AllDeviceArray) {
                if ([dict[TYPE] isEqualToString:GT10]) {
                    _device = dict[GT10];
                    [_deviceArray addObjectsFromArray:dict[GT10ARRAY]];
                }
            }
        }
//        _mapDetial = [[MapModelCSQ alloc]init];
    }
    return self;
}

/***********************************************************************
 * 方法名称： save
 * 功能描述： 保存用户信息
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)save
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_user];
    NSData* filterData = [NSKeyedArchiver archivedDataWithRootObject:_filterModel];
    NSData* GT10CarArrayData = [NSKeyedArchiver archivedDataWithRootObject:_GT10CarArray];
    NSData* AllDeviceData= [NSKeyedArchiver archivedDataWithRootObject:_AllDeviceArray];
    [userDefaults setObject:data forKey:@"UserInfo"];
    [userDefaults setObject:filterData forKey:@"filterData"];
    [userDefaults setObject:GT10CarArrayData forKey:@"GT10CarArrayData"];
//    [userDefaults setObject:_deviceArray forKey:@"DeviceArray"];
    [userDefaults setObject:AllDeviceData forKey:@"AllDeviceArray"];
    [userDefaults synchronize];
}

/***********************************************************************
 * 方法名称： clear
 * 功能描述： 清除用户信息
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)clear
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"UserInfo"];
    [userDefaults removeObjectForKey:@"DeviceInfo"];
    [userDefaults removeObjectForKey:@"DeviceArray"];
    [userDefaults removeObjectForKey:@"filterData"];
    [userDefaults synchronize];
}
+(NSString *)getDateStrFormNow{
    NSDate *myDate = [NSDate date];
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"date = %@",[dateFmt stringFromDate:myDate]);
    return [dateFmt stringFromDate:myDate];
}
+(NSString *)getDateDisplayString:(long long) miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"date = %@",[dateFmt stringFromDate:myDate]);
    return [dateFmt stringFromDate:myDate];
}
+(NSString *)getDateDisplayShortString:(long long) miliSeconds{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    dateFmt.dateFormat = @"yyyy-MM-dd";
    NSLog(@"date = %@",[dateFmt stringFromDate:myDate]);
    return [dateFmt stringFromDate:myDate];
}
+(long long)getTimerInterval:(NSString *) dateStr{
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSLog(@"date = %@",[dateFmt dateFromString:dateStr]);
    NSDate *myDate = [dateFmt dateFromString:dateStr];
    NSTimeInterval seconds = [myDate timeIntervalSince1970 ];
    return seconds * 1000.;
}


+(NSString *)changeDataStrWithStrInZero:(NSString*)zeroDataStr{
    
    
    
    NSDateFormatter *zeroDateFormat = [[NSDateFormatter alloc ] init];
    [zeroDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    zeroDateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *zeroDate = [zeroDateFormat dateFromString:zeroDataStr];
    
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc ] init];
    [localDateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    localDateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *localDateStr = [localDateFormat stringFromDate:zeroDate];

    return localDateStr;
}
+(NSString *)changeDataStrWithLocalToZero:(NSString*)localDataStr{
    
    
    
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc ] init];
//    [zeroDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
      [localDateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    localDateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *localDate = [localDateFormat dateFromString:localDataStr];
    
    NSDateFormatter *zeroFormat = [[NSDateFormatter alloc ] init];
    [zeroFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    zeroFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *zeroStr = [zeroFormat stringFromDate:localDate];
    
    return zeroStr;
}
+(NSString *)changeHourDataStrFromLocalToZero:(NSString*)localDataStr{
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc ] init];
    [localDateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    localDateFormat.dateFormat = @"HH:mm";
    NSDate *localDate = [localDateFormat dateFromString:localDataStr];
    
    NSDateFormatter *zeroFormat = [[NSDateFormatter alloc ] init];
    [zeroFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    zeroFormat.dateFormat = @"HH:mm";
    NSString *zeroStr = [zeroFormat stringFromDate:localDate];
    
    return zeroStr;
}
+(NSString *)changeHourDataStrFromZeroToLocal:(NSString*)zeroDataStr{
    NSDateFormatter *zeroDateFormat = [[NSDateFormatter alloc ] init];
    [zeroDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    zeroDateFormat.dateFormat = @"HH:mm";
    NSDate *zeroDate = [zeroDateFormat dateFromString:zeroDataStr];
    
    NSDateFormatter *localDateFormat = [[NSDateFormatter alloc ] init];
    [localDateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    localDateFormat.dateFormat = @"HH:mm";
    NSString *localDateStr = [localDateFormat stringFromDate:zeroDate];
    
    return localDateStr;
}
@end
