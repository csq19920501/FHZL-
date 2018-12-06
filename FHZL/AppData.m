/*
 ============================================================================
 Name        : AppData.m
 Version     : 1.0.0
 Copyright   : 
 Description : 全局数据
 ============================================================================
 */

#import "AppData.h"

#import "Header.h"
#import "SSKeychain.h"

@implementation AppData

NSInteger gAuditFlag = 0;
//从图片获取颜色
+(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width/2, image.size.height/2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}
//获取设备唯一标识符
+(NSString *)uuidString
{
    NSString *data = [SSKeychain passwordForService:@"weizhong_service" account:@"FHZL"];
    if (nil == data || data.length <= 0)
    {
        const char *str = "00:00:00:00:00:00";
        NSString *strUUID = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        NSInteger len = strUUID.length;
        if (len > 12)
        {
            str = [[NSString stringWithFormat:@"%C%C%C%C%C%C%C%C%C%C%C%C", [strUUID characterAtIndex:len-12], [strUUID characterAtIndex:len-11], [strUUID characterAtIndex:len-10], [strUUID characterAtIndex:len-9], [strUUID characterAtIndex:len-8], [strUUID characterAtIndex:len-7], [strUUID characterAtIndex:len-6], [strUUID characterAtIndex:len-5], [strUUID characterAtIndex:len-4], [strUUID characterAtIndex:len-3], [strUUID characterAtIndex:len-2], [strUUID characterAtIndex:len-1]] UTF8String];
        }
        data = [NSString stringWithUTF8String:str];
        [SSKeychain setPassword:data forService:@"weizhong_service" account:@"FHZL"];
    }
    return data;
}
//字典 转JSON字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
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
#pragma mark - 获取音频文件信息
+(NSString *)getVoiceFileInfoByPath:(NSString *)aFilePath convertTime:(NSTimeInterval)aConTime{
    
    NSInteger size = [self getFileSize:aFilePath]/1024;
    NSString *info = [NSString stringWithFormat:@"文件名:%@\n文件大小:%dkb\n",aFilePath.lastPathComponent,size];
    NSRange range = [aFilePath rangeOfString:@"wav"];
    if (range.length > 0) {
        
    }
    
    if (aConTime > 0)
        info = [info stringByAppendingFormat:@"转换时间:%f",aConTime];
    return info;
}

#pragma mark - 获取文件大小
+(NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}
+(NSString*)getFilePath:(NSString*)saveStr{
    return  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0] stringByAppendingString:saveStr];
}
+(UIViewController *)theTopviewControler{
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    return rootVC;
}
+(UIView *)theTopView{
    return  [UIApplication sharedApplication].keyWindow;
}
//判断是否纯数字
+(BOOL) deptNumInputShouldNumber:(NSString *)str
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}
//计算长度不包含空格
+(int)StrLength:(NSString *)string {
    return   [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
}

//判断手机号码
+(BOOL)valiMobile:(NSString *)mobile {
    
    if (mobile.length < 11) {
        return NO;
    } else {
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        } else {
            return NO;
        }
    }
    
    return YES;
}

//判断是否包含emoji表情
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}



//判断是否含有非法字符 yes 有  no没有
+(BOOL)JudgeTheillegalCharacter:(NSString *)content{
  
    NSRange urgentRange = [content rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}



//全局服务器地址选择
+(NSString *)httpServerUrl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"HTTPSERVERURL"] == nil) {
        return APPURLRELEASE;     //APPURLDEBUG   APPURLRELEASE //修改默认国外国内
    }else{
        return [userDefaults objectForKey:@"HTTPSERVERURL"];
    }
}
+(void)setHttpServerUrl:(NSString *)httpServerUrl{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:httpServerUrl forKey:@"HTTPSERVERURL"];
    [userDefaults synchronize];
}


//HTTP服务器IP


+(void)setServer:(NSString *)server
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:server forKey:@"SERVER"];
    [userDefaults synchronize];
}






//UDP服务器IP
+(NSString *)udpServer
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"UDPSERVER"])
    {
        return [userDefaults objectForKey:@"UDPSERVER"];
    }
    else
    {
        return @"58.250.50.53";
    }
}

+(void)setCourtTime:(long ) courtTime{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:courtTime forKey:@"courtTime"];
    [userDefaults synchronize];
}
+(long)courtTime
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults integerForKey:@"courtTime"])
    {
        return [userDefaults integerForKey:@"courtTime"];
    }
    else
    {
        return 3;
    }
}
+(void)setUdpServer:(NSString *)udpServer
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:udpServer forKey:@"UDPSERVER"];
    [userDefaults synchronize];
}
//UDP服务器IP
+(NSString *)jPushId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"jPushId"])
    {
        return [userDefaults objectForKey:@"UDPSERVER"];
    }
    else
    {
        return @"";
    }
}

+(void)setJPushId:(NSString *)jPushId
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:jPushId forKey:@"jPushId"];
    [userDefaults synchronize];
}
//UDP服务器端口
+(NSInteger)udpPort
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"UDPPORT"])
    {
        return [[userDefaults objectForKey:@"UDPPORT"] integerValue];
    }
    else
    {
        return 4755;
    }
}

+(void)setUdpPort:(NSInteger)udpPort
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)udpPort] forKey:@"UDPPORT"];
    [userDefaults synchronize];
}

//网络电话号码
+(NSString *)callCenterPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"CALLCENTERPHONE"])
    {
        return [userDefaults objectForKey:@"CALLCENTERPHONE"];
    }
    else
    {
        return NAVIGATION_PHONE;
    }
}

+(void)setCallCenterPhone:(NSString *)callCenterPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"(%@)",callCenterPhone] forKey:@"CALLCENTERPHONE"];
    [userDefaults synchronize];
}

//审核状态
+(NSInteger)auditFlag
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"auditFlag"])
    {
        return [[userDefaults objectForKey:@"auditFlag"]integerValue];
    }
    else
    {
        return gAuditFlag;
    }
}

+(void)setAuditFlag:(NSInteger)auditFlag
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%d",(int)auditFlag] forKey:@"auditFlag"];
    [userDefaults synchronize];
    
    gAuditFlag = auditFlag;
}

//设置地图(1:百度地图，2:高德地图，3:苹果地图，4:百度导航)

+(NSInteger)useMapType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger type = [userDefaults integerForKey:@"useMapType"]; //初始type为0
    if (0 == type)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]])
        {
            type = 1;
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        {
            type = 2;
        }
        else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"bdnavi://"]])
        {
            type = 4;
        }
        else
        {
            type = 3;
        }
    }
    return type;
}

+(void)setUseMapType:(NSInteger)useMapType
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:useMapType forKey:@"useMapType"];
    [userDefaults synchronize];
}

//后台记录足迹
+ (BOOL)trackOnBackground
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"trackOnBackground"];
}

+(void)setTrackOnBackground:(BOOL)trackOnBackground
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:trackOnBackground forKey:@"trackOnBackground"];
    [userDefaults synchronize];
}
//麦克风通道
+(BOOL)btMIC{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:@"isBtMIC"];
//    return NO;
}
+(void)setBtMIC:(BOOL)isBtMIC
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isBtMIC forKey:@"isBtMIC"];
    [userDefaults synchronize];
}

//保存发送导航页里接收人的手机号
+(NSString *)recieverPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"recieverPhone"];
}

+(void)setRecieverPhone:(NSString *)recieverPhone
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:recieverPhone forKey:@"recieverPhone"];
    [userDefaults synchronize];
}
+(NSString *)APP_Version{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}
+(void)setAlias{
    double delayInSeconds = 4.0f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                                      
    });
}
+(void)deleAlias{
    }
@end
