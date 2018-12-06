//
//  AppDelegate.m
//  FHZL
//
//  Created by hk on 17/12/11.
//  Copyright © 2017年 hk. All rights reserved.
//
#import "JSHAREService.h"
#import <Bugly/Bugly.h>
#import "LocationVC.h"
#import "AlarmListVC.h"
#import "CarListViewController.h"
#import "listenSoundVC.h"

#import "WXApi.h"
#import "iflyMSC/IFlyMSC.h"
#import "CYTabBarController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"


#import "loginVC.h"
#import "IQKeyboardManager.h"
#import "Header.h"
#import "SocialShareManager.h"

#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define L(key)  NSLocalizedString(key, nil)

#define BUGLY_APP_ID @"1833dea138"
@interface AppDelegate ()<JPUSHRegisterDelegate,BuglyDelegate>
{
    BMKMapManager* _mapManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setStyle];
    if (USERMANAGER.user.isLogined) {
        [self setRootMainVC];
    }else{
        [self setRootLoginVC];
    }
    
    
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:baiduKey generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    //注册微信支付
    [WXApi registerApp:WEIXINID withDescription:@"FHZL"];
    //注册分享
    DISPATCH_ON_GROUP_THREAD(^{
        [SocialShareManager sharedInstance].weChatAppkey = WEIXINID;  //wx733068420e37a279  wxc4f01596f4f7cb63
        [SocialShareManager sharedInstance].qqAppkey = @"1106695299";//1106275123   1104905706
        [[SocialShareManager sharedInstance] registerApp];
    })
    [self preparAudiosession];
//    [self yuyindaohang];
    [self setShare];
    [self setBadgeZero];
    //注册推送
#if !TARGET_IPHONE_SIMULATOR
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    // 3.0.0及以后版本注册可以这样写，也可以继续用旧的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            [AppData setJPushId:registrationID]; //171976fa8ab181411de
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
#endif
//    USERMANAGER.mapDetial = nil;
    USERMANAGER.mapDetial = [[MapModelCSQ alloc]init];
    [self setupBugly];
    return YES;
}
//设置极光分享
-(void)setShare{
    //除微信QQ其他key都是错误未曾设置的
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = @"817683c767bcd4eb4dc5e80a";
    config.SinaWeiboAppKey = @"374535501";
    config.SinaWeiboAppSecret = @"baccd12c166f1df96736b51ffbf600a2";
    config.SinaRedirectUri = @"https://www.jiguang.cn";
    config.QQAppId = @"1106695299";
    config.QQAppKey = @"glFYjkHQGSOCJHMC";
    config.WeChatAppId = @"wx690a4bd6d230f8f8";
    config.WeChatAppSecret = @"dcad950cd0633a27e353477c4ec12e7a";
    config.FacebookAppID = @"1847959632183996";
    config.FacebookDisplayName = @"JShareDemo";
    config.TwitterConsumerKey = @"4hCeIip1cpTk9oPYeCbYKhVWi";
    config.TwitterConsumerSecret = @"DuIontT8KPSmO2Y1oAvby7tpbWHJimuakpbiAUHEKncbffekmC";
    config.isSupportWebSina = YES;
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:NO];
}
-(void)setRootMainVC{

//        if (!kArrayIsEmpty(USERMANAGER.GT10CarArray)) {
            CYTabBarController *GT_10Tabbar = [[CYTabBarController alloc]init];
            [CYTabBarConfig shared].selectedTextColor = [UIColor colorWithRed:45/255. green:159/255. blue:254/255. alpha:1];

            UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:[LocationVC new]];
            UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:[CarListViewController new]];

            AlarmListVC *listVC = [[AlarmListVC alloc]init];
            listVC.selfType = All;
            UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:listVC];

            UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:[listenSoundVC new]];

            [GT_10Tabbar addChildController:nav1 title:L(@"Location") imageName:@"底部_定位_N.png" selectedImageName:@"底部_定位_P.png"];
            [GT_10Tabbar addChildController:nav2 title:L(@"list") imageName:@"底部_列表_N.png"  selectedImageName:@"底部_列表_P.png"];
            [GT_10Tabbar addChildController:nav3 title:L(@"Alarm message") imageName:@"底部_警报信息_N.png"  selectedImageName:@"底部_警报信息_P.png"];
            [GT_10Tabbar addChildController:nav4 title:L(@"Voice listening") imageName:@"底部_声音监听_N.png"  selectedImageName:@"底部_声音监听_P.png"];
            self.window.rootViewController = GT_10Tabbar;
//        }else{
//
//            HomeVC *homeVC = [[HomeVC alloc]init];
//            UINavigationController *nav = [[UINavigationController   alloc]initWithRootViewController:homeVC];
//            //默认开启系统右划返回
//            nav.interactivePopGestureRecognizer.enabled = NO;
//            self.window.rootViewController = nav;
//        }
    
}
-(void)setRootLoginVC{
    UINavigationController *nav = [[UINavigationController   alloc]initWithRootViewController:[loginVC new]];
    //默认开启系统右划返回
    nav.interactivePopGestureRecognizer.enabled = NO;
    self.window.rootViewController = nav;
}
-(void)setStyle{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    //设置APP键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [[UITextField appearance] setTintColor:[UIColor blackColor]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // 背景颜色
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    //字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    //导航栏背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"标题栏.png"] forBarMetrics:UIBarMetricsDefault];//searchBack  标题栏
    [UINavigationBar appearance].translucent = YES;
}
-(void)preparAudiosession{
    if(IOS_VERSION>=10.0) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:AVAudioSessionCategoryOptionAllowBluetoothA2DP                                           error:nil];
    }else{
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback    error:nil];
    }
    
}

//配置语音导航
#define APPID_VALUE           @"57732510" //57732510
-(void)yuyindaohang
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       //设置sdk的log等级，log保存在下面设置的工作路径中
                       [IFlySetting setLogFile:LVL_ALL];
                       
                       //打开输出在console的log开关
                       [IFlySetting showLogcat:NO];
                       
                       //设置sdk的工作路径
                       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                       NSString *cachePath = [paths objectAtIndex:0];
                       [IFlySetting setLogFilePath:cachePath];
                       
                       //创建语音配置，appid必须要传入，仅执行一次则可，所有服务启动前，需要确保执行createUtility
                       NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
                       [IFlySpeechUtility createUtility:initString];
                       
                   });
}
#pragma mark --- WXApiDelegate

- (void)onResp:(BaseResp *)resp
{
    //微信支付后的返回处理
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        switch (response.errCode)
        {
            case WXSuccess:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResponseSuccessNotification" object:nil userInfo:nil];
                break;
            }
            case WXErrCodeUserCancel:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResponseUserCancelNotification" object:nil userInfo:nil];
                break;
            }
            default:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PayResponseFailNotification" object:nil userInfo:nil];
                break;
            }
        }
    }
    //resp.code = 0  //微信绑定登录
    else if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp * resp1 = resp;
        
        NSLog(@"resp1 = %@ resp1.errCode = %d, resp.code = %@",resp1,resp1.errCode,resp1.code);
        NSLog(@"resp.state = %@ resp.lang = %@, resp.country = %@",resp1.state,resp1.lang,resp1.country);
        
        //        errCode
        //        errStr
        //        type
        
        if (resp1.errCode == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINIMAGEFirst" object:nil];
            
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [USER_PLIST setObject:authResp.code forKey:@"WEIXINCODE"];
            if (authResp.errCode == 0) {
                NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WEIXINID,WEIXINSECRET,authResp.code];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *zoneUrl = [NSURL URLWithString:url];
                    NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                    NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (data) {
                            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                            /*
                             {
                             "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
                             "expires_in" = 7200;
                             openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
                             "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
                             scope = "snsapi_userinfo,snsapi_base";
                             }
                             */
                            
                            NSString *weixin_token = [dic objectForKey:@"access_token"];
                            NSString *weixin_openid = [dic objectForKey:@"openid"];
                            NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",weixin_token,weixin_openid];
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSURL *zoneUrl = [NSURL URLWithString:url];
                                NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
                                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (data) {
                                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                        /*
                                         {
                                         city = Haidian;
                                         country = CN;
                                         headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
                                         language = "zh_CN";
                                         nickname = "xxx";
                                         openid = oyAaTjsDx7pl4xxxxxxx;
                                         privilege =     (
                                         );
                                         province = Beijing;
                                         sex = 1;
                                         unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
                                         }
                                         */
                                        
                                        
                                        
                                        
                                        USERMANAGER.user.headPicPath = [dic objectForKey:@"headimgurl"];
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINIMAGE" object:nil];
                                    }
                                });
                                
                            });
                        }
                    });
                });
            }
        }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINIMAGECancle" object:nil];
        }
    }
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:(id)self]; //WXApiDelegate
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:(id)self];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@", [NSString stringWithFormat:@"registrationID  Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"iOS6及以下系统，收到通知:%@", [self logDic:userInfo]);
    [JPUSHService handleRemoteNotification:userInfo];
    [self setBadgeZero];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 ) {
        if (userInfo[@"type"] != nil) {
            [self getRemoteNoti];
        }else{
            [self getRemoteNoti2];
        }
    }
    [self setBadgeZero];
    completionHandler(UIBackgroundFetchResultNewData);
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    [self setBadgeZero];
    

    
    
    
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
//        if (userInfo[@"pushType"] != nil) {
//            [self getRemoteNoti];
//
//        }else{
//            [self getRemoteNoti2];
//        }
        switch ([userInfo[@"pushType"] integerValue]) {
            case 1:
                {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"SoundPush" object:nil];
                }
                break;
            case 2:
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AlarmPush" object:nil];
            }
                break;
                
            default:
                break;
        }
    }
    else{
        // 判断为本地通知
        //         [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//点击通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    [self setBadgeZero];
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 点击通知收到远程通知:%@", [self logDic:userInfo]);
        
        if (userInfo[@"pushType"] != nil) {
//            self.drawerController = nil;
//            [CYTabBarConfig shared].selectIndex = 1;
//            [self setTabbar];
//            self.window.rootViewController = self.drawerController;
            
        }else{
//            self.drawerController = nil;
//            [CYTabBarConfig shared].selectIndex = 1;
//            [self setTabbar];
//            self.window.rootViewController = self.drawerController;
        }
        
        
        
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 这个不清楚什么情况收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
    [self setBadgeZero];
}
//接收到本地通知的处理
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


#endif


- (void)setupBugly {
    // Get the default config
    BuglyConfig * config = [[BuglyConfig alloc] init];
    
    // Open the debug mode to print the sdk log message.
    // Default value is NO, please DISABLE it in your RELEASE version.
    
    //    #if DEBUG
    //    config.debugMode = YES;
    //    #endif
    
    // Open the customized log record and report, BuglyLogLevelWarn will report Warn, Error log message.
    // Default value is BuglyLogLevelSilent that means DISABLE it.
    // You could change the value according to you need.
    //    config.reportLogLevel = BuglyLogLevelWarn;
    
    // Open the STUCK scene data in MAIN thread record and report.
    // Default value is NO
    config.blockMonitorEnable = YES;
    
    // Set the STUCK THRESHOLD time, when STUCK time > THRESHOLD it will record an event and report data when the app launched next time.
    // Default value is 3.5 second.
    config.blockMonitorTimeout = 1.5;
    
    // Set the app channel to deployment
    config.channel = @"Bugly";
    
    config.delegate = self;
    
    config.consolelogEnable = NO;
    config.viewControllerTrackingEnable = NO;
    
    // NOTE:Required
    // Start the Bugly sdk with APP_ID and your config
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    
    // Set the customizd tag thats config in your APP registerd on the  bugly.qq.com
    // [Bugly setTag:1799];
    
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
    
    [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
    
    // NOTE: This is only TEST code for BuglyLog , please UNCOMMENT it in your code.
    //    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
}
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
-(void)getRemoteNoti{}
-(void)getRemoteNoti2{}
-(void)setBadgeZero{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
}
@end
