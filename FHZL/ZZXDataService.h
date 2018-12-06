//
//  ZZXDataService.h
//  WeiZhong_ios
//
//  Created by hk on 16/8/30.
//
//

#import <Foundation/Foundation.h>
#import "NSString+addition.h"
#import "UserManager.h"
#import "AFNetworking.h"
#define  showErrorCode(block) else if ([data[@"code"]integerValue] == 101051){[UIUtil showToast:@"设备不在线" inView:[AppData theTopView]];block}else if ([data[@"code"]integerValue] == 101052){[UIUtil showToast:@"未连接到设备" inView:[AppData theTopView]];block}else if ([data[@"code"]integerValue] == 101055){[UIUtil showToast:@"车速过快，断电失败" inView:[AppData theTopView]];block}else if ([data[@"code"]integerValue] == 101052){[UIUtil showToast:@"GPS未定位，待GPS恢复后自动执行断油断电" inView:[AppData theTopView]];block}else if ([data[@"code"]integerValue] == 101057){[UIUtil showToast:@"已发送离线指令" inView:[AppData theTopView]];block}else{[UIUtil showToast:data[@"msg"] inView:self.view];block}
@interface ZZXDataService : NSObject
//字典转json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+(void)ZZXRequest:(NSString *)string
       httpMethod:(NSString *)method
          params1:(NSDictionary *)paramas1
          params2:(NSDictionary *)paramas2
             file:(NSDictionary *)files
          success:(void(^)(id data))success
             fail:(void(^)(NSError *error))fail;

+(void)ZZXNoSignRequest:(NSString *)string
             httpMethod:(NSString *)method
                params1:(NSDictionary *)paramas1
                params2:(NSDictionary *)paramas2
                   file:(NSDictionary *)files
                success:(void(^)(id data))success
                   fail:(void(^)(NSError *error))fail;

//获取车的位置(未使用)
+(void)ZZXGetCarLocation:(NSDictionary *)paramas success:(void(^)(id data))success
               fail:(void(^)(NSError *error))fail;

//设置电子围栏(未使用)
+(void)ZZXSetEnclosure:(NSDictionary *)paramas success:(void(^)(id data))success
               fail:(void(^)(NSError *error))fail;
//绑定设备(未使用)

+(void)ZZXUserRelevanceMac:(NSDictionary *)paramas success:(void(^)(id data))success
               fail:(void(^)(NSError *error))fail;
+(void)HFZLRequest:(NSString *)string
        httpMethod:(NSString *)method
           params1:(NSDictionary *)paramas1
//          params2:(NSDictionary *)paramas2
              file:(NSDictionary *)files
           success:(void(^)(id data))success
              fail:(void(^)(NSError *error))fail;
//添加语言
+(void)dictionaryAddLaungage:(NSMutableDictionary*)dictT;
@end
