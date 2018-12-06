/*
 ============================================================================
 Name        : NSString+addition.h
 Version     : 1.0.0
 Copyright   : 
 Description : NSString addition functions
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>


@interface NSString (addition)

- (NSString*)md5HexDigest;
- (NSString*)urlEncode;

+ (NSString*)stringWithTime:(NSDate*)time isIncludeTime:(BOOL)isIncludeTime;

@end