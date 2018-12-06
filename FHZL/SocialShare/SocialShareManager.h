/*
 ============================================================================
 Name        : SocialShareManager.h
 Version     : 1.0.0
 Copyright   : 
 Description : 分享管理类
 ============================================================================
 */

#import <Foundation/Foundation.h>


typedef enum ShareToApp
{
    ShareToApp_WeChat, // 分享到微信好友
    ShareToApp_QQ,     // 分享到QQ好友
} ShareToApp;

@interface SocialShareManager : NSObject
{
}

@property (nonatomic, retain) NSString* shareUrl;

@property (nonatomic, retain) NSString* weChatAppkey;
@property (nonatomic, retain) NSString* qqAppkey;

+ (SocialShareManager*)sharedInstance;
+ (void)destroyInstance;

- (void)registerApp;

// 分享文字
- (void)sendShareText:(NSString*)text toApp:(ShareToApp)app;

// 分享文件
- (void)sendShareFile:(NSString*)filePath toApp:(ShareToApp)app;

@end
