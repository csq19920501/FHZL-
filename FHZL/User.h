/*
 ============================================================================
 Name        : user.h
 Version     : 1.0.0
 Copyright   : 
 Description : 用户类
 ============================================================================
 */

#import <Foundation/Foundation.h>

#define LoginStatusChangedNotification    @"LoginStatusChangedNotification"
#define AddBankCardNotification           @"AddBankCardNotification"
#define RefreshDataNotification           @"RefreshDataNotification"


@interface User2 : NSObject<NSCoding>
{
}

@property (nonatomic, copy) NSString* accoundID; // 账号
@property (nonatomic, copy) NSString* password; // 密码
@property (nonatomic, copy) NSString* nickname; // 昵称
@property (nonatomic, copy) NSString* serviceEndDate; // 服务终止日期
@property (nonatomic, copy) NSString* mobilePhone; // 主号
@property (nonatomic, copy) NSString* phone1; // 副卡1
@property (nonatomic, copy) NSString* phone2; // 副卡2
@property (nonatomic, copy) NSString* phone3; // 副卡3
@property (nonatomic, copy) NSString* phone4; // 副卡4  改用邮箱
@property (nonatomic, copy) NSString* SrvCardEndDate; // 服务终止日期
@property (nonatomic, assign) NSInteger remainingDays; // 剩余天数

@property (nonatomic, assign) BOOL isLogined; // 用户是否登陆
@property (nonatomic, assign) BOOL isOtherLogined; // 用户是否在别处登陆
@property (nonatomic, copy) NSString * userID; // 用户ID
@property (nonatomic, copy) NSString* appCookie; // Cookie值
@property (nonatomic, copy) NSString* userSecretKey; // 加密后的用户识别码
@property (nonatomic, copy) NSString* macID; //
@property (nonatomic, copy) NSString* iconId; //
@property (nonatomic, copy) NSString* IMEI; //
@property (nonatomic, copy) NSString* token; //
@property (nonatomic, copy) NSString* headPicPath; //
@property (nonatomic, copy) NSString* upPicPath;
@property (nonatomic, copy) NSString* loginType; //
- (id)init;

@end
