//
//  ZZXDataService.m
//  WeiZhong_ios
//
//  Created by hk on 16/8/30.
//
#import "NSDictionary+SetNullWithStr.h"
#import "ZZXDataService.h"
#import "Header.h"
#import "AppData.h"
#define kBaseURL @""
#define APPURL @"http://www.ifengstar.com/api.do"//未使用





#define AppUrl [AppData httpServerUrl]//@"http://113.106.93.254/api"
#define ServiceBuild @"v1"
#define ServiceVersion @"1"


@implementation ZZXDataService

-(NSString *)createMd5Sign:(NSDictionary *)dict
{
    NSMutableString *contentString = [NSMutableString string];
    NSMutableString *secretString = [NSMutableString string];
    [contentString appendFormat:@"{"];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray)
    {
        if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"\"%@\":\"%@\",", categoryId, [dict objectForKey:categoryId]];
            [secretString appendFormat:@"%@",[dict objectForKey:categoryId]];
        }
    }
    [secretString appendString:[[UserManager sharedInstance].user.password md5HexDigest]];
    [contentString appendFormat:@"\"%@\":\"%@\"}", @"appSecret", [secretString md5HexDigest]];
    
    return contentString;
}

-(NSDictionary *)greatDict:(NSDictionary *)params1 :(NSDictionary *)params2
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params1];
    NSArray *keys = [params1 allKeys];
    for (NSString *categoryId in keys)
    {
        if ([[params1 objectForKey:categoryId] isEqualToString:@""])
        {
            [mutableDict setObject:[self createMd5Sign:params2] forKey:categoryId];
        }
    }
    return mutableDict;
}

//请求参数自动带有appSecret，不需要在外面添加
+(void)ZZXRequest:(NSString *)string
       httpMethod:(NSString *)method
          params1:(NSDictionary *)paramas1
          params2:(NSDictionary *)paramas2
             file:(NSDictionary *)files
          success:(void(^)(id data))success
             fail:(void(^)(NSError *error))fail
{
    //获取appSecret
    NSMutableString *contentString = [NSMutableString string];
    NSMutableString *secretString = [NSMutableString string];
    [contentString appendFormat:@"{"];
    NSArray *keys = [paramas2 allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch]; //NSNumericSearch:比较字符串的字符个数，而不是字符值
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray)
    {
        if (![[paramas2 objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"\"%@\":\"%@\",", categoryId, [paramas2 objectForKey:categoryId]];
            [secretString appendFormat:@"%@",[paramas2 objectForKey:categoryId]];
        }
    }
    [secretString appendString:[[UserManager sharedInstance].user.password md5HexDigest]];
    [contentString appendFormat:@"\"%@\":\"%@\"}", @"appSecret", [secretString md5HexDigest]];
    
    //拼装字典
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:paramas1];
    NSArray *key2s = [paramas1 allKeys];
    for (NSString *categoryId in key2s)
    {
        if ([[paramas1 objectForKey:categoryId] isEqualToString:@""])
        {
            [mutableDict setObject:contentString forKey:categoryId]; //mutableDict = @{@"a":@"user",@"m":@"getCarLocation",@"arg":@"{\"appFlag\":\"3\",...,\"appSecret\":\"...\"}"}
        }
    }
    
    //1.拼接地址
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseURL, string];
    
    //2.编码
    NSString *encodeURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
//    
//    [manager1 POST:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask *task, id responseObject)
//    {
//        if (success)
//        {
//            success(responseObject);
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error)
//    {
//        if (fail)
//        {
//            fail(error);
//        }
//    }];

    //3.构造一个操作对象的管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //3.1
    //设置解析格式JSON，默认JSON
    //设置解析XML:[AFXMLParserResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
    
    
    
     
    
    
    
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        //4.GET请求
        
//        [manager GET:encodeURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        }
//             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                 
//                 NSLog(@"这里打印请求成功要做的事");
//                 if (success)
//                 {
//                    success(responseObject);
//                 }
//                 
//             }
//             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//                 
//                 NSLog(@"%@",error);  //这里打印错误信息
//                                if (fail)
//                                  {
//                                      fail(error);
//                                  }
//             }];
        
        
        [manager GET:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if (success)
             {
                 success(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
         {
             if (fail)
             {
                 fail(error);
                 [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
             }
         }];
    }
    else if ([[method uppercaseString] isEqualToString:@"POST"])
    {
        if (files == nil)
        {
            //POST请求(不包括文件)
            [manager POST:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     success(responseObject);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
        }
        else
        {
            [manager POST:encodeURL parameters:mutableDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 if (files != nil)
                 {
                     for (id key in files)
                     {
                         id value = files[key];
                         [formData appendPartWithFileData:value name:key fileName:@"header.png" mimeType:@"image/png"];
                     }
                 }
                 
             } success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     success(responseObject);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
        }
    }
}

//请求参数没有带appSecret，需要在外面添加
+(void)ZZXNoSignRequest:(NSString *)string
       httpMethod:(NSString *)method
          params1:(NSDictionary *)paramas1
          params2:(NSDictionary *)paramas2
             file:(NSDictionary *)files
          success:(void(^)(id data))success
             fail:(void(^)(NSError *error))fail
{
    //获取appSecret
    NSMutableString *contentString = [NSMutableString string];
    NSMutableString *secretString = [NSMutableString string];
    [contentString appendFormat:@"{"];
    NSArray *keys = [paramas2 allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray)
    {
        if (![[paramas2 objectForKey:categoryId] isEqualToString:@""])
        {
            [contentString appendFormat:@"\"%@\":\"%@\",", categoryId, [paramas2 objectForKey:categoryId]];
            [secretString appendFormat:@"%@",[paramas2 objectForKey:categoryId]];
        }
    }

    contentString = (NSMutableString *)[contentString substringToIndex:contentString.length - 1]; //去掉最后面的逗号
    NSMutableString *contentString2 = [NSMutableString string];
    [contentString2 appendString:contentString];
    [contentString2 appendFormat:@"}"];
    //拼装字典
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:paramas1];
    NSArray *key2s = [paramas1 allKeys];
    for (NSString *categoryId in key2s)
    {
        if ([[paramas1 objectForKey:categoryId] isEqualToString:@""])
        {
            [mutableDict setObject:contentString2 forKey:categoryId];
        }
    }
    
    [self dictionaryAddLaungage:mutableDict];
    
    //1.拼接地址
    NSString *requestURL = [NSString stringWithFormat:@"%@%@", kBaseURL, string];
    
    //2.编码
    NSString *encodeURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //3.构造一个操作对象的管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //3.1
    //设置解析格式JSON，默认JSON
    //设置解析XML:[AFXMLParserResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        //4.GET请求
        [manager GET:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
         {
             if (success)
             {
                 success(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
         {
             if (fail)
             {
                 fail(error);
                 [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
             }
         }];
    }
    else if ([[method uppercaseString] isEqualToString:@"POST"])
    {
        if (files == nil)
        {
            //POST请求(不包括文件)
            [manager POST:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     success(responseObject);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
        }
        else
        {
            [manager POST:encodeURL parameters:mutableDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 if (files != nil)
                 {
                     for (id key in files)
                     {
                         id value = files[key];
                         [formData appendPartWithFileData:value name:key fileName:@"header.png" mimeType:@"image/png"];
                     }
                 }
                 
             } success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     success(responseObject);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
        }
    }
}

//获取车的位置(未使用)
+(void)ZZXGetCarLocation:(NSDictionary *)paramas success:(void(^)(id data))success
                    fail:(void(^)(NSError *error))fail
{
    [self ZZXNoSignRequest:APPURL
                httpMethod:@"POST"
                   params1:@{@"a":@"user",@"m":@"getCarLocation",@"arg":@""}
                   params2:(NSDictionary *)paramas
                      file:nil
                   success:(void(^)(id data))success
                      fail:(void(^)(NSError *error))fail];
}

//设置电子围栏(未使用)
+(void)ZZXSetEnclosure:(NSDictionary *)paramas success:(void(^)(id data))success
                  fail:(void(^)(NSError *error))fail
{
    [self ZZXNoSignRequest:APPURL
                httpMethod:@"POST"
                   params1:@{@"a":@"user",@"m":@"setEnclosure",@"arg":@""}
                   params2:(NSDictionary *)paramas
                      file:nil
                   success:(void(^)(id data))success
                      fail:(void(^)(NSError *error))fail];
}

//绑定设备(未使用)
+(void)ZZXUserRelevanceMac:(NSDictionary *)paramas success:(void(^)(id data))success
                      fail:(void(^)(NSError *error))fail
{
    [self ZZXNoSignRequest:APPURL
                httpMethod:@"POST"
                   params1:@{@"a":@"user",@"m":@"userRelevanceMac",@"arg":@""}
                   params2:(NSDictionary *)paramas
                      file:nil
                   success:(void(^)(id data))success
                      fail:(void(^)(NSError *error))fail];
}


//请求参数自动带有appSecret，不需要在外面添加
+(void)HFZLRequest:(NSString *)string
       httpMethod:(NSString *)method
          params1:(NSDictionary *)paramas1
             file:(NSDictionary *)files
          success:(void(^)(id data))success
             fail:(void(^)(NSError *error))fail
{
    NSDate *nowDate = [NSDate date];
    NSTimeInterval seconds = [nowDate timeIntervalSince1970 ];
  
    //拼装字典
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setObject:ServiceVersion forKey:@"version"];
    [mutableDict setObject:[NSString stringWithFormat:@"%lld",(long long)seconds * 1000] forKey:@"tm"];//
    [mutableDict setObject:CsqStringIsEmpty(USERMANAGER.user.token) forKey:@"token"];
    [mutableDict setObject:[AppData uuidString] forKey:@"deviceId"];
    [self dictionaryAddLaungage:mutableDict];
    
    NSMutableDictionary *paramasMutable = [NSMutableDictionary dictionaryWithDictionary:paramas1] ;
    [mutableDict setObject:[self convertToJsonData:paramasMutable] forKey:@"args"];
    
    //获取appSecret
    NSMutableString *secretString = [NSMutableString string];
    NSArray *keys = [mutableDict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                            {
                                return [obj1 compare:obj2 options:NSNumericSearch]; //NSNumericSearch:比较字符串的字符个数，而不是字符值
                            }];
    //拼接字符串
    for (NSString *categoryId in sortedArray)
    {
        [secretString appendFormat:@"%@%@",categoryId,[mutableDict objectForKey:categoryId]];
    }
    [secretString appendFormat:@"%@",CsqStringIsEmpty(USERMANAGER.user.token)];
//    [secretString appendFormat:@"%@",CsqStringIsEmpty([mutableDict objectForKey:@"language"])];
    
    
    [mutableDict setObject:[[secretString md5HexDigest]uppercaseString] forKey:@"secret"];
    
    //1.拼接地址
    NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@", AppUrl,ServiceBuild, string];

    //2.编码
    NSString *encodeURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //http://113.106.93.254/api/v1/sms/verify-code
    
    
    //3.构造一个操作对象的管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //3.1
    //设置解析格式JSON，默认JSON
    //设置解析XML:[AFXMLParserResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",nil];
    if ([[method uppercaseString] isEqualToString:@"GET"])
    {
        [manager GET:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             if (success)
             {
                 success(responseObject);
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
         {
             if (fail)
             {
                 fail(error);
                 [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
             }
         }];
    }
    else if ([[method uppercaseString] isEqualToString:@"POST"])
    {
        if (files == nil)
        {
            //POST请求(不包括文件)
            [manager POST:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     
                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                         //主要将字典空值转换成@“”将nsumer 转换成nsstring
                         responseObject = [NSDictionary changeType:responseObject];
                         // 添加打印
                         SDLog(@"data = %@  data.msg = %@   dict= %@",responseObject,responseObject[@"msg"],mutableDict);
                     }
                     switch ([responseObject[@"code"]integerValue]) {
                         case 201011:
                         {
                             if (![string isEqualToString:@"user/logout"]) {
                                 [UIUtil showToast:@"请重新登录" inView:[AppData theTopView]];
                                 return ;
                             }
                         }
                             break;
                         default:
                            
                             break;
                     }
                     success(responseObject);
                 }
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
        }
        else
        {
            
            [manager POST:encodeURL parameters:mutableDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 if (files != nil)
                 {
//                     for (id key in files)
//                     {
//                         id value = files[key];
//                         [formData appendPartWithFileData:value name:key fileName:@"header.png" mimeType:@"image/png"];
//                     }
                     
                     
                     NSArray *pictureArray = files[@"files"];
                     for (id key in pictureArray)
                     {
                         SDLog(@"添加图片");
                         [formData appendPartWithFileData:key name:files[@"apiName"] fileName:@"file.png" mimeType:@"image/png"];
                     }
                     
//                     UIImage *image = [UIImage imageNamed:@"testPicture.png"];
//                     NSData *data = UIImageJPEGRepresentation(image,1);

//                     [formData appendPartWithFileData:data name:@"files" fileName:@"files.png" mimeType:@"image/png"];
//                     [formData appendPartWithFileData:data name:@"files" fileName:@"files.png" mimeType:@"image/png"];
//                     [formData appendPartWithFileData:data name:@"files" fileName:@"files.png" mimeType:@"image/png"];
                     
                 }
             } success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
             {
                 if (success)
                 {
                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                         //主要将字典空值转换成@“”将nsumer 转换成nsstring
                         responseObject = [NSDictionary changeType:responseObject];
                         // 添加打印
                         SDLog(@"data = %@  data.msg = %@   dict= %@",responseObject,responseObject[@"msg"],mutableDict);
                     }
                     success(responseObject);
                 }

             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
             {
                 if (fail)
                 {
                     
                     fail(error);
                     [UIUtil showToast:L(@"Network exception") inView:[AppData theTopView]];
                 }
             }];
//            [manager POST:encodeURL parameters:mutableDict success:^(NSURLSessionDataTask * _Nullable task, id responseObject)
//             {
//                 if (success)
//                 {
//                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                         //主要将字典空值转换成@“”将nsumer 转换成nsstring
//                         responseObject = [NSDictionary changeType:responseObject];
//                         // 添加打印
//                         NSLog(@"data = %@  data.msg = %@   dict= %@",responseObject,responseObject[@"msg"],mutableDict);
//                     }
//                     success(responseObject);
//                 }
//
//             } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error)
//             {
//                 if (fail)
//                 {
//                     fail(error);
//                 }
//             }];
        }
    }
}
//字典转json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        SDLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//添加语言
+(void)dictionaryAddLaungage:(NSMutableDictionary*)dictT{
    NSString *languageStr = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    if ([languageStr isEqualToString:@"zh"]) {
        languageStr = @"CN";
    }else if([languageStr isEqualToString:@"es"]){
        languageStr = @"ES";
    }else{
        languageStr = @"US";
    }
    [dictT setObject:@"US" forKey:@"language"];
}
@end
