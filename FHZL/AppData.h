/*
 ============================================================================
 Name        : AppData.h
 Version     : 1.0.0
 Copyright   : 
 Description : 全局数据
 ============================================================================
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define NAVIGATION_PHONE (@"0755-36806328") //人工导航电话
#define HOTLINE_PHONE    (@"0755-88851085") //情感热线电话
#define SHARE_URL        (@"http://a.app.qq.com/o/simple.jsp?pkgname=com.hk.carnet.HKFHZL") //好友邀请链接
#define APPTYPE @"HKFHZL"
#define GAODEKEY @"5e25970dfec439cda013b496bac2301e"
#define WEIXINID @"wx690a4bd6d230f8f8"    //wx7064e33e500f55dc
#define WEIXINKEY @""
#define WEIXINSECRET @"000a554ea0c0e9ce768179ceab4e0e27"    // a8ff2be21c75ac3d9c4eaa4d7cfd92fa
@interface AppData : NSObject
//全局服务器选择
+(NSString *)httpServerUrl;
+(void)setHttpServerUrl:(NSString *)httpServerUrl;
//设置分段时间
+(void)setCourtTime:(long ) courtTime;
//获取分段时间
+(long)courtTime;

//从图片获取颜色
+(UIColor*)mostColor:(UIImage*)image;
//获取设备唯一标识符
+(NSString *)uuidString;
//字典 转JSON字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//获取音频文件信;
+(NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime;
//获取文件大小
+(NSInteger)getFileSize:(NSString*) path;
//拼接存储路径
+(NSString*)getFilePath:(NSString*)saveStr;
//获取最上层viewControl
+(UIViewController *)theTopviewControler;
//获取最上层UI
+(UIView *)theTopView;
//判断是否纯数字
+(BOOL) deptNumInputShouldNumber:(NSString *)str;
//计算字符长度不包含空格
+(int)StrLength:(NSString*)string;
//判断手机号码
+(BOOL)valiMobile:(NSString *)mobile;
//判断是否包含表情
+(BOOL)stringContainsEmoji:(NSString *)string;
//判断是否包含非法字符
+(BOOL)JudgeTheillegalCharacter:(NSString *)content;
//HTTP服务器IP
+(NSString *)server;
+(void)setServer:(NSString *)server;
//UDP服务器IP
+(NSString *)udpServer;
+(void)setUdpServer:(NSString *)udpServer;

//UDP服务器端口
+(NSInteger)udpPort;
+(void)setUdpPort:(NSInteger)udpPort;

//网络电话号码
+(NSString *)callCenterPhone;
+(void)setCallCenterPhone:(NSString *)callCenterPhone;

//审核状态
+(NSInteger)auditFlag;
+(void)setAuditFlag:(NSInteger)auditFlag;

//设置地图(1:百度地图，2:高德地图，3:苹果地图，4:百度导航)
+(NSInteger)useMapType;
+(void)setUseMapType:(NSInteger)useMapType;

//后台记录足迹
+(BOOL)trackOnBackground;
+(void)setTrackOnBackground:(BOOL)trackOnBackground;

//保存发送导航页里接收人的手机号
+(NSString *)recieverPhone;
+(void)setRecieverPhone:(NSString *)recieverPhone;


//获取版本号
+(NSString *)APP_Version;

//麦克风通道
+(BOOL)btMIC;
+(void)setBtMIC:(BOOL)isBtMIC;
//设置极光推送alias
+(void)setAlias;
//删除极光推送alias
+(void)deleAlias;
//UDP服务器IP
+(NSString *)jPushId;
+(void)setJPushId:(NSString *)jPushId;
@end
