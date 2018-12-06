#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 
+ (NSString *)csqpinyinFromChinese:(NSString *)string;
+ (NSString *) CsqGetForwadTwoCharFromChiniseString:(NSString *)string;
@end
