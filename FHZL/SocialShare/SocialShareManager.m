/*
 ============================================================================
 Name        : SocialShareManager.m
 Version     : 1.0.0
 Copyright   : 
 Description : 分享管理类
 ============================================================================
 */

#import "SocialShareManager.h"
#import "WXApi.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import "TencentOpenAPI/TencentOAuth.h"
#import "NSString+addition.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "LocalizedStringTool.h"


@interface SocialShareManager ()
{
}

@end

@implementation SocialShareManager

@synthesize weChatAppkey;
@synthesize qqAppkey;

static SocialShareManager* _sharedInstance;

+ (SocialShareManager*)sharedInstance
{
    if (nil == _sharedInstance)
    {
        _sharedInstance = [[SocialShareManager alloc] init];
    }
    
	return _sharedInstance;
}

+ (void)destroyInstance
{
    if (nil != _sharedInstance)
    {
        _sharedInstance = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    
    return self;
}

- (void)registerApp
{
    // 注册微信分享
    [WXApi registerApp:self.weChatAppkey];
    
    // 注册QQ分享
    [[TencentOAuth alloc] initWithAppId:qqAppkey andDelegate:nil];
}

// 分享文字
- (void)sendShareText:(NSString*)text toApp:(ShareToApp)app
{
    switch (app)
    {
        case ShareToApp_WeChat:
            [self sendShareTextToWeChat:text];
            break;
            
        case ShareToApp_QQ:
            [self sendShareTextToQQ:text];
            break;
        
        default:
            break;
    }
}

// 分享文件
- (void)sendShareFile:(NSString*)filePath toApp:(ShareToApp)app
{
    switch (app)
    {
        case ShareToApp_WeChat:
            [self sendShareFileToWeChat:filePath];
            break;
            
        case ShareToApp_QQ:
            [self sendShareFileToQQ:filePath];
            break;
            
        default:
            break;
    }
}

- (void)sendShareTextToWeChat:(NSString*)text
{
    if (![WXApi isWXAppInstalled])
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = L(@"NotWechatInstalled");
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.0f];
        
        return;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.bText = YES;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void)sendShareFileToWeChat:(NSString*)filePath
{
    if (![WXApi isWXAppInstalled])
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = L(@"NotWechatInstalled");
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.0f];
        
        return;
    }
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = filePath.lastPathComponent;
    req.bText = NO;
    req.scene = WXSceneSession;
    
    WXMediaMessage* message = [WXMediaMessage message];
    message.title = filePath.lastPathComponent;
    message.description = filePath.lastPathComponent;
    WXFileObject* object = [[WXFileObject alloc] init];
    object.fileExtension = @"zip";
    object.fileData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = object;
    req.message = message;
    
    [WXApi sendReq:req];
}

- (void)sendShareTextToQQ:(NSString*)text
{
    if (![QQApiInterface isQQInstalled])
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = L(@"NotQQInstalled");
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.0f];
        
        return;
    }
    
    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:text];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
    [QQApiInterface sendReq:req];
}

- (void)sendShareFileToQQ:(NSString*)filePath
{
    if (![QQApiInterface isQQInstalled])
    {
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = L(@"NotQQInstalled");
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.0f];
        
        return;
    }
    
    QQApiFileObject* object = [[QQApiFileObject alloc] init];
    object.fileName = filePath.lastPathComponent;
    object.data = [NSData dataWithContentsOfFile:filePath];
    [object setCflag:kQQAPICtrlFlagQQShareDataline];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:object];
    [QQApiInterface sendReq:req];
}

@end
