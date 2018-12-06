/*
 ============================================================================
 Name        : user.m
 Version     : 1.0.0
 Copyright   : 
 Description : 用户类
 ============================================================================
 */

#import "User.h"
#import "Header.h"
#import "JPUSHService.h"
@interface User2 ()
{
    BOOL _isLogined;
}

@end

@implementation User2

@synthesize isLogined = _isLogined;

/***********************************************************************
 * 方法名称： init
 * 功能描述： 生成用户
 * 输入参数：
 * 输出参数：
 * 返回值：   用户
 ***********************************************************************/
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

/***********************************************************************
 * 方法名称： initWithCoder
 * 功能描述： 生成用户
 * 输入参数：
 * 输出参数：
 * 返回值：   用户
 ***********************************************************************/
- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.accoundID       = [aDecoder decodeObjectForKey:@"accoundID"];
        self.IMEI       = [aDecoder decodeObjectForKey:@"IMEI"];
        self.appCookie       = [aDecoder decodeObjectForKey:@"username"];
        self.password       = [aDecoder decodeObjectForKey:@"password"];
        self.nickname       = [aDecoder decodeObjectForKey:@"nickname"];
        self.serviceEndDate = [aDecoder decodeObjectForKey:@"serviceEndDate"];
        self.mobilePhone    = [aDecoder decodeObjectForKey:@"mobilePhone"];
        self.phone1         = [aDecoder decodeObjectForKey:@"phone1"];
        self.phone2         = [aDecoder decodeObjectForKey:@"phone2"];
        self.phone3         = [aDecoder decodeObjectForKey:@"phone3"];
        self.phone4         = [aDecoder decodeObjectForKey:@"phone4"];
        self.SrvCardEndDate = [aDecoder decodeObjectForKey:@"SrvCardEndDate"];
        self.remainingDays  = [aDecoder decodeIntegerForKey:@"remainingDays"];
        self.userID  = [aDecoder decodeObjectForKey:@"userID"];

        self.iconId  =        [aDecoder decodeObjectForKey:@"iconId"];//
        self.token  =        [aDecoder decodeObjectForKey:@"token"];//
        self.loginType  =        [aDecoder decodeObjectForKey:@"loginType"];//
        self.isLogined  =     [aDecoder decodeBoolForKey:@"isLogined"];//
        self.headPicPath  =     [aDecoder decodeObjectForKey:@"headPicPath"];
        self.upPicPath  =     [aDecoder decodeObjectForKey:@"upPicPath"];
    }
    return self;
}

/***********************************************************************
 * 方法名称： encodeWithCoder
 * 功能描述： 用户解码
 * 输入参数：
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.upPicPath forKey:@"upPicPath"];
    [aCoder encodeObject:self.headPicPath forKey:@"headPicPath"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.loginType forKey:@"loginType"];
    [aCoder encodeObject:self.accoundID forKey:@"accoundID"];
    [aCoder encodeObject:self.IMEI forKey:@"IMEI"];
    [aCoder encodeObject:self.appCookie forKey:@"username"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.serviceEndDate forKey:@"serviceEndDate"];
    [aCoder encodeObject:self.mobilePhone forKey:@"mobilePhone"];
    [aCoder encodeObject:self.phone1 forKey:@"phone1"];
    [aCoder encodeObject:self.phone2 forKey:@"phone2"];
    [aCoder encodeObject:self.phone3 forKey:@"phone3"];
    [aCoder encodeObject:self.phone4 forKey:@"phone4"];
    [aCoder encodeObject:self.SrvCardEndDate forKey:@"SrvCardEndDate"];
    [aCoder encodeInteger:self.remainingDays forKey:@"remainingDays"];
    [aCoder encodeObject:self.userID forKey:@"userID"];

    [aCoder encodeObject:self.iconId forKey:@"iconId"];
    [aCoder encodeBool:self.isLogined  forKey:@"isLogined"];
}

/***********************************************************************
 * 方法名称： setIsLogined
 * 功能描述： 设置是否登录
 * 输入参数： isLogined 登录状态
 * 输出参数：
 * 返回值：
 ***********************************************************************/
- (void)setIsLogined:(BOOL)isLogined
{
    _isLogined = isLogined;
    
    if (_isLogined)
    {
        self.isOtherLogined = NO;
    }
    else
    {
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq){
            if (iResCode == 0) {
                NSLog(@"极光推送alias删除成功");
            }
        }                       seq:2];
    }
    // 通知界面刷新登录显示
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStatusChangedNotification object:nil];
}
-(void)setUserID:(NSString *)userID{
    _userID = userID;
    if (!kStringIsEmpty(userID)) {
        [JPUSHService setAlias:userID
                    completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq){
                        if (iResCode == 0) {
                            NSLog(@"极光推送alias设置成功");
                            NSLog(@"极光推送alias  userManager.user.userId = %@",[UserManager sharedInstance].user.userID);
                        }
                    }                       seq:1];
    }else{
        
    }
}
@end
